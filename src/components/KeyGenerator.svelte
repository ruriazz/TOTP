<script lang="ts">
  import { generateSecretKey } from '$utils/totp';
  import { secretKey } from '$stores/totp';
  
  export let keyLength: number = 160;
  
  function onGenerateKey() {
    const newKey = generateSecretKey(keyLength);
    $secretKey = newKey;
  }
  
  // Generate initial key on component mount
  if (!secretKey) {
    onGenerateKey();
  }
</script>

<div class="section">
  <h3>Secret Key Generator</h3>
  
  <div class="input-group">
    <label for="keyLength">Key Length (bits):</label>
    <select id="keyLength" bind:value={keyLength}>
      <option value={80}>80 bits</option>
      <option value={128}>128 bits</option>
      <option value={160}>160 bits (Recommended)</option>
      <option value={256}>256 bits</option>
    </select>
  </div>
  
  <button class="btn" on:click={onGenerateKey}>Generate New Secret Key</button>
  
  <div class="input-group">
    <label for="secretKey">Secret Key (Base32):</label>
    <input 
      id="secretKey" 
      type="text" 
      value={$secretKey}
      placeholder="Your secret key will appear here..."
      readonly
    />
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

  .input-group input, .input-group select {
    width: 100%;
    padding: 12px;
    border: 2px solid #e0e0e0;
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.3s ease;
  }

  .input-group input:focus, .input-group select:focus {
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
</style>
