<script lang="ts">
  import { hotp } from '$utils/totp';
  import { totpConfig, secretKey } from '$stores/totp';
  
  let userOTP: string = '';
  let verificationResult: { isValid: boolean; message: string; validWindow?: string } | null = null;
  
  async function verifyOTP() {
    if (!$secretKey) {
      alert('Please generate a secret key first!');
      return;
    }
    
    if (!userOTP.trim()) {
      alert('Please enter an OTP to verify!');
      return;
    }
    
    try {
      // Generate current TOTP for verification
      const currentTimeCounter = Math.floor(Date.now() / 1000 / $totpConfig.timeStep);
      const currentOTP = await hotp($secretKey, currentTimeCounter, $totpConfig.digits, $totpConfig.algorithm as any);
      
      let isValid = false;
      let validWindow = '';
      let validOTPs = [`Current: ${currentOTP}`];
      
      // Check current window
      if (userOTP.trim() === currentOTP) {
        isValid = true;
        validWindow = 'Current window';
      }
      
      // Check previous windows based on clock skew tolerance
      for (let i = 1; i <= $totpConfig.clockSkew && !isValid; i++) {
        const pastOTP = await hotp($secretKey, currentTimeCounter - i, $totpConfig.digits, $totpConfig.algorithm as any);
        validOTPs.push(`-${i}: ${pastOTP}`);
        if (userOTP.trim() === pastOTP) {
          isValid = true;
          validWindow = `${i} window${i > 1 ? 's' : ''} ago`;
        }
      }
      
      if (isValid) {
        verificationResult = {
          isValid: true,
          message: `✅ Valid OTP! (${validWindow})`,
          validWindow
        };
      } else {
        verificationResult = {
          isValid: false,
          message: `❌ Invalid OTP. Expected one of: ${validOTPs.join(', ')}`
        };
      }
      
      // Clear input after verification
      userOTP = '';
      
      // Clear result after 5 seconds
      setTimeout(() => {
        verificationResult = null;
      }, 5000);
      
    } catch (error) {
      console.error('Error verifying OTP:', error);
      verificationResult = {
        isValid: false,
        message: '❌ Error during verification'
      };
    }
  }
  
  function handleKeyPress(event: KeyboardEvent) {
    if (event.key === 'Enter') {
      verifyOTP();
    }
  }
</script>

<div class="section">
  <h3>OTP Verification</h3>
  
  <div class="input-group">
    <label for="userOTP">Enter OTP to Verify:</label>
    <input 
      id="userOTP" 
      type="text" 
      bind:value={userOTP}
      on:keypress={handleKeyPress}
      placeholder="Enter the OTP code..."
      maxlength={$totpConfig.digits}
    />
  </div>
  
  <button class="btn" on:click={verifyOTP}>Verify OTP</button>
  
  {#if verificationResult}
    <div class="verification-result" class:valid={verificationResult.isValid} class:invalid={!verificationResult.isValid}>
      {verificationResult.message}
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

  .input-group {
    margin-bottom: 20px;
  }

  .input-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #34495e;
  }

  .input-group input {
    width: 100%;
    padding: 12px;
    border: 2px solid #e0e0e0;
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.3s ease;
  }

  .input-group input:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
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

  .verification-result {
    padding: 15px;
    border-radius: 8px;
    margin: 15px 0;
    font-weight: 600;
    text-align: center;
  }

  .verification-result.valid {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
    color: white;
  }

  .verification-result.invalid {
    background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
    color: #721c24;
  }
</style>
