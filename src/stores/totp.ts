import { writable } from 'svelte/store';
import type { TOTPConfig, TOTPState } from '$types/types';

// TOTP Configuration Store
export const totpConfig = writable<TOTPConfig>({
    timeStep: 30,
    digits: 6,
    algorithm: 'SHA-1',
    clockSkew: 1
});

// TOTP State Store
export const totpState = writable<TOTPState>({
    secretKey: '',
    otpCode: '',
    timeLeft: 0,
    progress: 0,
    isActive: false
});

// Secret Key Store
export const secretKey = writable<string>('');
