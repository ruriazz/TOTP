<script lang="ts">
  import { onMount, onDestroy } from 'svelte';
  import type { TOTPState } from '$types/types';
  import { totp, generateSecretKey } from '$utils/totp';
  import { totpConfig, totpState, secretKey } from '$stores/totp';
  
  let localTotpState: TOTPState = {
    secretKey: '',
    otpCode: '',
    timeLeft: 0,
    progress: 0,
    isActive: false
  };
  
  let interval: number;
  
  onMount(() => {
    if (!$secretKey) {
      $secretKey = generateSecretKey();
    }
  });
  
  onDestroy(() => {
    if (interval) {
      clearInterval(interval);
    }
  });
  
  async function startTOTP() {
    if (!$secretKey) {
      alert('Please generate a secret key first!');
      return;
    }
    
    localTotpState.isActive = true;
    $totpState = { ...$totpState, isActive: true };
    
    if (interval) {
      clearInterval(interval);
    }
    
    await updateTOTP();
    interval = setInterval(updateTOTP, 1000);
  }
  
  async function updateTOTP() {
    const now = Math.floor(Date.now() / 1000);
    const timeLeft = $totpConfig.timeStep - (now % $totpConfig.timeStep);
    const progress = (($totpConfig.timeStep - timeLeft) / $totpConfig.timeStep) * 100;
    
    try {
      const otpCode = await totp(
        $secretKey, 
        $totpConfig.timeStep, 
        $totpConfig.digits, 
        $totpConfig.algorithm as any
      );
      
      localTotpState = {
        ...localTotpState,
        otpCode,
        timeLeft,
        progress
      };
      
      $totpState = {
        secretKey: $secretKey,
        otpCode,
        timeLeft,
        progress,
        isActive: true
      };
    } catch (error) {
      console.error('Error generating TOTP:', error);
    }
  }
  
  function stopTOTP() {
    if (interval) {
      clearInterval(interval);
    }
    localTotpState.isActive = false;
    $totpState = { ...$totpState, isActive: false };
  }
</script>

<div class="section">
  <h3>Current TOTP</h3>
  
  {#if !localTotpState.isActive}
    <button class="btn" on:click={startTOTP}>Start TOTP Generation</button>
  {:else}
    <button class="btn" on:click={stopTOTP}>Stop TOTP Generation</button>
  {/if}
  
  {#if localTotpState.isActive}
    <div class="otp-display">
      <div class="otp-code">{localTotpState.otpCode || '------'}</div>
      <div class="otp-timer">Time remaining: {localTotpState.timeLeft} seconds</div>
      <div class="progress-bar">
        <div class="progress-fill" style="width: {localTotpState.progress}%"></div>
      </div>
    </div>
  {/if}
</div>

<style>
  .section {
    background: white;
    border-radius: 15px;
    padding: 25px;
    margin-bottom: 25px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
    border-left: 5px solid #667eea;
  }

  .section h3 {
    color: #2c3e50;
    margin-bottom: 20px;
    font-size: 1.4rem;
    display: flex;
    align-items: center;
  }

  .section h3::before {
    content: "🔐";
    margin-right: 10px;
    font-size: 1.2rem;
  }

  .btn {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    padding: 15px 30px;
    border-radius: 10px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    width: 100%;
    margin-top: 10px;
  }

  .btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
  }

  .btn:active {
    transform: translateY(0);
  }

  .otp-display {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
    color: white;
    padding: 30px;
    border-radius: 15px;
    text-align: center;
    margin: 20px 0;
    box-shadow: 0 10px 30px rgba(17, 153, 142, 0.3);
  }

  .otp-code {
    font-size: 3rem;
    font-weight: 700;
    letter-spacing: 0.2em;
    margin-bottom: 10px;
    font-family: 'Courier New', monospace;
  }

  .otp-timer {
    font-size: 1.2rem;
    opacity: 0.9;
  }

  .progress-bar {
    width: 100%;
    height: 6px;
    background: rgba(255, 255, 255, 0.3);
    border-radius: 3px;
    margin-top: 15px;
    overflow: hidden;
  }

  .progress-fill {
    height: 100%;
    background: white;
    transition: width 1s linear;
    border-radius: 3px;
  }

  @media (max-width: 768px) {
    .otp-code {
      font-size: 2.5rem;
    }
  }
</style>
