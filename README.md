# 🔒 TOTP Security Generator

![TOTP](https://img.shields.io/badge/TOTP-RFC%206238-blue)
![Security](https://img.shields.io/badge/Security-HMAC%20Based-green)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-ES6+-F7DF1E?logo=javascript&logoColor=black)

Time-based One-Time Password (TOTP) generator yang mengimplementasikan standar **RFC 6238** dengan interface web yang user-friendly dan fitur keamanan.

## 📋 Daftar Isi

- [Overview](#-overview)
- [Fitur Utama](#-fitur-utama)
- [Teknologi](#-teknologi)
- [Cara Penggunaan](#-cara-penggunaan)
- [Konfigurasi Keamanan](#-konfigurasi-keamanan)
- [Implementasi TOTP](#-implementasi-totp)
- [Spesifikasi Teknis](#-spesifikasi-teknis)
- [Best Practices](#-best-practices)
- [Browser Support](#-browser-support)
- [Security Notice](#-security-notice)

## 🎯 Overview

TOTP Security Generator adalah implementasi **Time-based One-Time Password** yang mengikuti standar internasional RFC 6238. Aplikasi ini menyediakan:

- **Generator secret key** dengan multiple level keamanan
- **TOTP generation** real-time dengan countdown timer
- **OTP verification** dengan clock skew tolerance
- **Multiple hash algorithms** (SHA-1, SHA-256, SHA-512)
- **Responsive UI** dengan modern design

## ✨ Fitur Utama

### 🔐 Secret Key Management
- **Multi-level key generation**: 160-bit, 256-bit, 512-bit
- **Base32 encoding** sesuai standar RFC 3548
- **Cryptographically secure random** menggunakan Web Crypto API

### ⏱️ TOTP Configuration
- **Time steps**: 30 detik (standard) atau 60 detik
- **OTP length**: 6 digit (standard) atau 8 digit
- **Hash algorithms**: SHA-1, SHA-256, SHA-512
- **Clock skew tolerance**: 0-2 windows untuk fleksibilitas

### 🛡️ Security Features
- **Time-bound validation** - OTP berlaku dalam window waktu terbatas
- **HMAC-based authentication** untuk integritas data
- **Clock synchronization tolerance** untuk real-world usage
- **No data persistence** - semua data di memory browser

### 📱 User Interface
- **Real-time countdown** dengan progress bar visual
- **Responsive design** untuk desktop dan mobile
- **Modern gradient UI** dengan smooth animations
- **Accessibility friendly** dengan proper labeling

## 🔧 Teknologi

- **Frontend**: HTML5, CSS3, Vanilla JavaScript (ES6+)
- **Cryptography**: Web Crypto API (SubtleCrypto)
- **Standards**: RFC 6238 (TOTP), RFC 4226 (HOTP), RFC 3548 (Base32)
- **Security**: HMAC-SHA1/256/512, Cryptographically secure random

## 🚀 Cara Penggunaan

### 1. Setup
```bash
# Clone atau download repository
git clone <repository-url>

# Buka index.html di browser
open index.html
```

### 2. Generate Secret Key
1. Pilih **key length** (160/256/512-bit)
2. Klik **"Generate New Secret Key"**
3. Secret key dalam format Base32 akan muncul

### 3. Konfigurasi TOTP
- **Time Step**: Interval waktu OTP (default: 30 detik)
- **OTP Length**: Panjang kode OTP (default: 6 digit)
- **Hash Algorithm**: Algoritma hash (default: SHA-1)
- **Clock Skew**: Toleransi sinkronisasi waktu

### 4. Generate & Verify OTP
1. Klik **"Start TOTP Generation"**
2. OTP akan ditampilkan dengan countdown timer
3. Masukkan OTP di field verification untuk testing
4. Klik **"Verify OTP"** untuk validasi

## 🔧 Konfigurasi Keamanan

### Time Step Configuration
```javascript
const timeSteps = {
  standard: 30,    // 30 seconds (RFC 6238 default)
  extended: 60     // 60 seconds (custom)
};
```

### OTP Length Options
```javascript
const otpLengths = {
  standard: 6,     // 6 digits (most common)
  enhanced: 8      // 8 digits (higher security)
};
```

### Hash Algorithm Support
```javascript
const algorithms = {
  'SHA-1':   'Standard RFC 6238',
  'SHA-256': 'Enhanced security',
  'SHA-512': 'Maximum security'
};
```

### Clock Skew Tolerance
- **Strict Mode (0)**: OTP hanya valid di window saat ini
- **Standard Mode (1)**: OTP valid di window saat ini + 1 window sebelumnya
- **Relaxed Mode (2)**: OTP valid di window saat ini + 2 window sebelumnya

## 🔬 Implementasi TOTP

### Core Algorithm Flow
```javascript
// 1. Generate time-based counter
const timeCounter = Math.floor(Date.now() / 1000 / timeStep);

// 2. Generate HOTP using counter
const hotpValue = await hotp(secretKey, timeCounter, digits, algorithm);

// 3. Return time-based OTP
return hotpValue;
```

### HMAC Implementation
```javascript
async function hmac(algorithm, key, data) {
    const cryptoKey = await crypto.subtle.importKey(
        'raw', key, { name: 'HMAC', hash: algorithm }, false, ['sign']
    );
    const signature = await crypto.subtle.sign('HMAC', cryptoKey, data);
    return new Uint8Array(signature);
}
```

### Dynamic Truncation (RFC 4226)
```javascript
const offset = hmacResult[hmacResult.length - 1] & 0x0f;
const binary = (
    ((hmacResult[offset] & 0x7f) << 24) |
    ((hmacResult[offset + 1] & 0xff) << 16) |
    ((hmacResult[offset + 2] & 0xff) << 8) |
    (hmacResult[offset + 3] & 0xff)
);
const otp = binary % Math.pow(10, digits);
```

## 📐 Spesifikasi Teknis

### Key Generation
- **Entropy Source**: `crypto.getRandomValues()`
- **Key Lengths**: 160-bit (20 bytes), 256-bit (32 bytes), 512-bit (64 bytes)
- **Encoding**: Base32 (RFC 3548)

### Time Synchronization
- **Unix Timestamp**: `Math.floor(Date.now() / 1000)`
- **Time Windows**: 30s atau 60s intervals
- **Clock Drift Handling**: ±1-2 windows tolerance

### Hash Functions
- **SHA-1**: 160-bit output (RFC 6238 standard)
- **SHA-256**: 256-bit output (enhanced security)
- **SHA-512**: 512-bit output (maximum security)

### OTP Generation
- **Counter-based**: `floor(unixTime / timeStep)`
- **HMAC Input**: 64-bit big-endian counter
- **Truncation**: Dynamic offset (RFC 4226)
- **Modulo Operation**: `% 10^digits`

## 🎯 Best Practices

### Production Implementation
```javascript
// ✅ Good: Use secure key storage
const secretKey = await getFromSecureStorage('totp-secret');

// ❌ Bad: Hardcode secret keys
const secretKey = 'JBSWY3DPEHPK3PXP';
```

### Security Recommendations
- 🔐 **Secret Storage**: Gunakan HSM atau encrypted storage
- 🕐 **Time Sync**: Pastikan server time akurat (NTP)
- 🛡️ **Rate Limiting**: Implementasi rate limiting untuk verification
- 📱 **Backup Codes**: Sediakan backup authentication methods

### Development Guidelines
- ✅ Use Web Crypto API untuk random generation
- ✅ Implement proper error handling
- ✅ Validate user inputs
- ✅ Use HTTPS in production
- ❌ Jangan simpan secret key di localStorage
- ❌ Jangan log sensitive data

## 🌐 Browser Support

| Browser | Version | Web Crypto API | Support |
|---------|---------|----------------|---------|
| Chrome  | 37+     | ✅             | ✅      |
| Firefox | 34+     | ✅             | ✅      |
| Safari  | 7+      | ✅             | ✅      |
| Edge    | 12+     | ✅             | ✅      |

### Required APIs
- `crypto.getRandomValues()` - Secure random generation
- `crypto.subtle.importKey()` - Key import
- `crypto.subtle.sign()` - HMAC computation
- `DataView` - Binary data manipulation

## 🚨 Security Notice

### Production Considerations
1. **Secret Key Management**: Secret keys harus disimpan dengan enkripsi kuat dan tidak pernah dikirim melalui channel yang tidak aman
2. **HSM Usage**: Untuk aplikasi enterprise, gunakan Hardware Security Module (HSM)
3. **Key Rotation**: Implementasikan rotasi key secara berkala
4. **Audit Logging**: Log semua authentication attempts
5. **Rate Limiting**: Implementasi rate limiting untuk mencegah brute force

### Development vs Production
- **Development**: File ini cocok untuk testing dan development
- **Production**: Memerlukan backend implementation dengan proper secret management
- **Demo Only**: Current implementation adalah proof-of-concept

## 📄 References

- [RFC 6238 - TOTP](https://tools.ietf.org/rfc/rfc6238.txt)
- [RFC 4226 - HOTP](https://tools.ietf.org/rfc/rfc4226.txt)
- [RFC 3548 - Base32](https://tools.ietf.org/rfc/rfc3548.txt)
- [Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API)

---

**⚡ Quick Start**: Buka `index.html` di browser modern, generate secret key, dan mulai generate TOTP!

**🔒 Security First**: Selalu ikuti security best practices untuk implementasi production.

**📧 Support**: Untuk questions atau contributions, silakan buat issue di repository.