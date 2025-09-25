import type { HashAlgorithm } from '$types/types';

// Base32 encoding/decoding
const base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

export function base32Encode(buffer: Uint8Array): string {
    let result = '';
    let bits = 0;
    let value = 0;
    
    for (let i = 0; i < buffer.length; i++) {
        value = (value << 8) | buffer[i];
        bits += 8;
        
        while (bits >= 5) {
            bits -= 5;
            result += base32Chars[(value >>> bits) & 31];
        }
    }
    
    if (bits > 0) {
        result += base32Chars[(value << (5 - bits)) & 31];
    }
    
    // Add padding
    while (result.length % 8 !== 0) {
        result += '=';
    }
    
    return result;
}

export function base32Decode(str: string): Uint8Array {
    str = str.toUpperCase().replace(/=+$/, '');
    let result = new Uint8Array(Math.floor(str.length * 5 / 8));
    let bits = 0;
    let value = 0;
    let index = 0;
    
    for (let i = 0; i < str.length; i++) {
        const char = str[i];
        const charIndex = base32Chars.indexOf(char);
        if (charIndex === -1) continue;
        
        value = (value << 5) | charIndex;
        bits += 5;
        
        if (bits >= 8) {
            bits -= 8;
            result[index++] = (value >>> bits) & 255;
        }
    }
    
    return result.slice(0, index);
}

// HMAC implementation - simplified approach
export async function hmac(algorithm: HashAlgorithm, key: Uint8Array, data: ArrayBuffer): Promise<Uint8Array> {
    try {
        const cryptoKey = await crypto.subtle.importKey(
            'raw', 
            key as any, // Type assertion to bypass TS strict mode
            { name: 'HMAC', hash: algorithm }, 
            false, 
            ['sign']
        );
        const signature = await crypto.subtle.sign('HMAC', cryptoKey, data);
        return new Uint8Array(signature);
    } catch (error) {
        console.error('HMAC error:', error);
        throw error;
    }
}

// Generate secure random key
export function generateSecretKey(length: number = 160): string {
    const keyBytes = crypto.getRandomValues(new Uint8Array(length / 8));
    return base32Encode(keyBytes);
}

// HOTP implementation
export async function hotp(secret: string, counter: number, digits: number = 6, algorithm: HashAlgorithm = 'SHA-1'): Promise<string> {
    const key = base32Decode(secret);
    const counterBuffer = new ArrayBuffer(8);
    const counterView = new DataView(counterBuffer);
    counterView.setBigUint64(0, BigInt(counter), false);
    
    const hmacResult = await hmac(algorithm, key, counterBuffer);
    
    // Dynamic truncation (RFC 4226)
    const offset = hmacResult[hmacResult.length - 1] & 0x0f;
    const binary = (
        ((hmacResult[offset] & 0x7f) << 24) |
        ((hmacResult[offset + 1] & 0xff) << 16) |
        ((hmacResult[offset + 2] & 0xff) << 8) |
        (hmacResult[offset + 3] & 0xff)
    );
    
    const otp = binary % Math.pow(10, digits);
    return otp.toString().padStart(digits, '0');
}

// TOTP implementation
export async function totp(secret: string, timeStep: number = 30, digits: number = 6, algorithm: HashAlgorithm = 'SHA-1'): Promise<string> {
    const now = Math.floor(Date.now() / 1000);
    const timeCounter = Math.floor(now / timeStep);
    return await hotp(secret, timeCounter, digits, algorithm);
}
