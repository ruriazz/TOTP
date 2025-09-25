# 🔒 TOTP Security Generator

![TOTP](https://img.shields.io/badge/TOTP-RFC%206238-blue)
![Security](https://img.shields.io/badge/Security-HMAC%20Based-green)
![Svelte](https://img.shields.io/badge/Svelte-FF3E00?logo=svelte&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-646CFF?logo=vite&logoColor=white)

Time-based One-Time Password (TOTP) generator yang mengimplementasikan standar **RFC 6238** dengan modern web framework dan fitur keamanan lengkap.

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

TOTP Security Generator adalah implementasi **Time-based One-Time Password** yang mengikuti standar internasional RFC 6238. Aplikasi ini dibangun dengan **Svelte 5** dan **TypeScript** untuk performa optimal dan type safety. Menyediakan:

- **Generator secret key** dengan multiple level keamanan
- **TOTP generation** real-time dengan countdown timer
- **OTP verification** dengan clock skew tolerance
- **Multiple hash algorithms** (SHA-1, SHA-256, SHA-512)
- **Modern component architecture** dengan reactive state management

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
- **Component-based architecture** dengan Svelte 5
- **Reactive state management** dengan Svelte stores
- **Real-time countdown** dengan progress bar visual
- **Responsive design** untuk desktop dan mobile
- **Modern gradient UI** dengan smooth animations
- **Type-safe development** dengan TypeScript

## 🔧 Teknologi

- **Frontend Framework**: Svelte 5 dengan SvelteKit architecture
- **Language**: TypeScript untuk type safety
- **Build Tool**: Vite dengan Rolldown bundler
- **State Management**: Svelte stores (reactive)
- **Cryptography**: Web Crypto API (SubtleCrypto)
- **Standards**: RFC 6238 (TOTP), RFC 4226 (HOTP), RFC 3548 (Base32)

## 🚀 Cara Penggunaan

### 1. Setup Development
```bash
# Clone atau download repository
git clone https://github.com/ruriazz/TOTP.git
cd totp

# Install dependencies
npm install

# Start development server
npm run dev

# Build untuk production
npm run build

# Preview production build
npm run preview
```

### 2. Project Structure
```
totp/
├── src/
│   ├── components/          # Svelte components
│   │   ├── KeyGenerator.svelte
│   │   ├── TOTPConfig.svelte
│   │   ├── TOTPDisplay.svelte
│   │   └── TOTPVerifier.svelte
│   ├── stores/             # State management
│   │   └── totp.ts
│   ├── types/              # TypeScript definitions
│   │   └── types.ts
│   ├── utils/              # Utility functions
│   │   └── totp.ts
│   ├── App.svelte          # Main application
│   └── main.ts             # Entry point
├── vite.config.ts          # Vite configuration
└── package.json
```

### 3. Generate Secret Key
1. Pilih **key length** (160/256/512-bit)
2. Klik **"Generate New Secret Key"**
3. Secret key dalam format Base32 akan muncul

### 4. Konfigurasi TOTP
- **Time Step**: Interval waktu OTP (default: 30 detik)
- **OTP Length**: Panjang kode OTP (default: 6 digit)
- **Hash Algorithm**: Algoritma hash (default: SHA-1)
- **Clock Skew**: Toleransi sinkronisasi waktu

### 5. Generate & Verify OTP
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

### Architecture Overview
```typescript
// 1. State Management (Svelte Stores)
export const totpConfig = writable<TOTPConfig>({
  timeStep: 30,
  digits: 6,
  algorithm: 'SHA-1',
  clockSkew: 1
});

// 2. Component Structure
KeyGenerator     → Generate secret keys
TOTPConfig      → Configure TOTP parameters  
TOTPDisplay     → Show OTP with countdown
TOTPVerifier    → Verify OTP codes
```

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
```typescript
// ✅ Good: Use Svelte stores for state management
import { totpConfig, secretKey } from '$stores/totp';
import { generateSecretKey } from '$utils/totp';

// ✅ Good: Type-safe configuration
const config: TOTPConfig = {
  timeStep: 30,
  digits: 6,
  algorithm: 'SHA-1',
  clockSkew: 1
};

// ❌ Bad: Direct DOM manipulation
document.getElementById('secret').value = 'JBSWY3DPEHPK3PXP';
```

### Security Recommendations
- 🔐 **Secret Storage**: Gunakan HSM atau encrypted storage
- 🕐 **Time Sync**: Pastikan server time akurat (NTP)
- 🛡️ **Rate Limiting**: Implementasi rate limiting untuk verification
- 📱 **Backup Codes**: Sediakan backup authentication methods

### Development Guidelines
- ✅ Use TypeScript untuk type safety
- ✅ Implement Svelte reactive statements
- ✅ Use stores untuk state management
- ✅ Follow component composition patterns
- ✅ Use proper error handling
- ✅ Validate user inputs with TypeScript types
- ✅ Use HTTPS in production
- ❌ Jangan simpan secret key di localStorage
- ❌ Jangan log sensitive data
- ❌ Jangan bypass TypeScript type checking

## 🌐 Browser Support

| Browser | Version | Web Crypto API | Svelte Support | Support |
|---------|---------|----------------|----------------|---------|
| Chrome  | 37+     | ✅             | ✅             | ✅      |
| Firefox | 34+     | ✅             | ✅             | ✅      |
| Safari  | 7+      | ✅             | ✅             | ✅      |
| Edge    | 12+     | ✅             | ✅             | ✅      |

### Required APIs & Features
- `crypto.getRandomValues()` - Secure random generation
- `crypto.subtle.importKey()` - Key import
- `crypto.subtle.sign()` - HMAC computation
- `DataView` - Binary data manipulation
- ES Modules support - Modern JavaScript features
- TypeScript support (development) - Type checking

## 🚨 Security Notice

### Production Considerations
1. **Secret Key Management**: Secret keys harus disimpan dengan enkripsi kuat dan tidak pernah dikirim melalui channel yang tidak aman
2. **HSM Usage**: Untuk aplikasi enterprise, gunakan Hardware Security Module (HSM)
3. **Key Rotation**: Implementasikan rotasi key secara berkala
4. **Audit Logging**: Log semua authentication attempts
5. **Rate Limiting**: Implementasi rate limiting untuk mencegah brute force

### Development vs Production
- **Development**: Menggunakan Vite dev server dengan HMR
- **Production**: Build dengan Vite dan optimasi bundle
- **TypeScript**: Type checking dalam development dan build
- **Components**: Modular Svelte components untuk maintainability
- **Demo Ready**: Siap untuk demo dan development testing

## 📄 References

- [RFC 6238 - TOTP](https://tools.ietf.org/rfc/rfc6238.txt)
- [RFC 4226 - HOTP](https://tools.ietf.org/rfc/rfc4226.txt)
- [RFC 3548 - Base32](https://tools.ietf.org/rfc/rfc3548.txt)
- [Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API)
- [Svelte Documentation](https://svelte.dev/docs)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Vite Guide](https://vitejs.dev/guide/)

---

**⚡ Quick Start**: `npm install && npm run dev`, kemudian buka browser di `http://localhost:5173`

**🔒 Security First**: Selalu ikuti security best practices untuk implementasi production.

**📧 Support**: Untuk questions atau contributions, silakan buat issue di repository.