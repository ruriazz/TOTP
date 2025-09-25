<script lang="ts">
  import { KeyGenerator, TOTPConfig, TOTPDisplay, TOTPVerifier } from '$lib/components';
</script>

<div class="container">
  <div class="header">
    <h1>🔒 TOTP Security Generator</h1>
    <p>Time-based One-Time Password - RFC 6238 Implementation</p>
  </div>

  <div class="content">
    <KeyGenerator />
    <TOTPConfig />
    <TOTPDisplay />
    <TOTPVerifier />
    
    <div class="info-box">
      <h4>🔒 Security Features</h4>
      <div class="security-features">
        <div class="feature-card">
          <h5>RFC 6238 Compliant</h5>
          <p>Follows industry standards</p>
        </div>
        <div class="feature-card">
          <h5>Multiple Algorithms</h5>
          <p>SHA-1, SHA-256, SHA-512</p>
        </div>
        <div class="feature-card">
          <h5>Clock Skew Tolerance</h5>
          <p>Handles time differences</p>
        </div>
        <div class="feature-card">
          <h5>Secure Key Generation</h5>
          <p>Cryptographically secure</p>
        </div>
      </div>
    </div>

    <div class="warning">
      <strong>⚠️ Security Warning:</strong> This implementation is for educational purposes. 
      In production, ensure proper key storage, secure transmission, and consider additional 
      security measures like rate limiting and audit logging.
    </div>
  </div>
</div>

<style>
  * {
    box-sizing: border-box;
  }

  :global(body) {
    font-family: 'Segoe UI', system-ui, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    padding: 20px;
    margin: 0;
  }

  .container {
    max-width: 800px;
    margin: 0 auto;
    background: rgba(255, 255, 255, 0.95);
    border-radius: 20px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(10px);
    overflow: hidden;
  }

  .header {
    background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
    color: white;
    padding: 30px;
    text-align: center;
  }

  .header h1 {
    font-size: 2.5rem;
    margin-bottom: 10px;
    font-weight: 300;
  }

  .header p {
    opacity: 0.9;
    font-size: 1.1rem;
  }

  .content {
    padding: 40px;
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

  .security-features {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 15px;
    margin-top: 20px;
  }

  .feature-card {
    background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
    padding: 20px;
    border-radius: 10px;
    text-align: center;
    color: #8b4513;
  }

  .feature-card h5 {
    margin-bottom: 8px;
    font-size: 1.1rem;
  }

  .warning {
    background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
    border: 1px solid #ff6b6b;
    color: #721c24;
    padding: 15px;
    border-radius: 8px;
    margin: 15px 0;
  }

  @media (max-width: 768px) {
    .container {
      margin: 10px;
    }
    
    .content {
      padding: 20px;
    }
    
    .header h1 {
      font-size: 2rem;
    }
  }
</style>
