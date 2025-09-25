// Types for TOTP application
export interface TOTPConfig {
    timeStep: number;
    digits: number;
    algorithm: string;
    clockSkew: number;
}

export interface TOTPState {
    secretKey: string;
    otpCode: string;
    timeLeft: number;
    progress: number;
    isActive: boolean;
}

export type HashAlgorithm = 'SHA-1' | 'SHA-256' | 'SHA-512';
