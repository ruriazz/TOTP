<script lang="ts">
  import { totpConfig } from '$stores/totp';
</script>

<div class="section">
  <h3>TOTP Configuration</h3>
  
  <div class="input-group">
    <label for="timeStep">Time Step (seconds):</label>
    <select id="timeStep" bind:value={$totpConfig.timeStep}>
      <option value={15}>15 seconds</option>
      <option value={30}>30 seconds (Standard)</option>
      <option value={60}>60 seconds</option>
      <option value={120}>120 seconds</option>
    </select>
  </div>
  
  <div class="input-group">
    <label for="digits">OTP Digits:</label>
    <select id="digits" bind:value={$totpConfig.digits}>
      <option value={6}>6 digits (Standard)</option>
      <option value={7}>7 digits</option>
      <option value={8}>8 digits</option>
    </select>
  </div>
  
  <div class="input-group">
    <label for="algorithm">Hash Algorithm:</label>
    <select id="algorithm" bind:value={$totpConfig.algorithm}>
      <option value="SHA-1">SHA-1 (Standard)</option>
      <option value="SHA-256">SHA-256</option>
      <option value="SHA-512">SHA-512</option>
    </select>
  </div>
  
  <div class="input-group">
    <label for="clockSkew">Clock Skew Tolerance:</label>
    <select id="clockSkew" bind:value={$totpConfig.clockSkew}>
      <option value={0}>0 windows (Strict)</option>
      <option value={1}>1 window (Recommended)</option>
      <option value={2}>2 windows</option>
      <option value={3}>3 windows</option>
    </select>
  </div>
  
  <div class="info-box">
    <h4>⚙️ Configuration Info</h4>
    <p>• Time Step: How often the OTP changes</p>
    <p>• Digits: Length of the generated OTP</p>
    <p>• Algorithm: Hash function for security</p>
    <p>• Clock Skew: Tolerance for time differences</p>
  </div>
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

  .input-group select {
    width: 100%;
    padding: 12px;
    border: 2px solid #e0e0e0;
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.3s ease;
  }

  .input-group select:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  }

  .info-box {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
    padding: 20px;
    border-radius: 10px;
    margin: 20px 0;
  }

  .info-box h4 {
    margin-bottom: 10px;
    font-size: 1.2rem;
  }

  .info-box p {
    margin: 5px 0;
    font-size: 0.9rem;
  }
</style>
