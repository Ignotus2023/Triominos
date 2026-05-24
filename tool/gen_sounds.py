"""Generuje krótkie syntetyczne efekty dźwiękowe (WAV) dla TriominoScore.

Uruchom: python3 tool/gen_sounds.py
"""
import math
import os
import struct
import wave

SR = 44100
OUT = "assets/sounds"


def _adsr(t: float, dur: float, attack: float = 0.008, release: float = 0.06) -> float:
    if t < attack:
        return t / attack
    if t > dur - release:
        return max(0.0, (dur - t) / release)
    return 1.0


def render(notes, total: float, vol: float = 0.5) -> bytes:
    n = int(SR * total)
    buf = [0.0] * n
    for freq, start, dur in notes:
        s = int(start * SR)
        e = min(n, int((start + dur) * SR))
        for i in range(s, e):
            t = (i - s) / SR
            buf[i] += math.sin(2 * math.pi * freq * t) * _adsr(t, dur)
    peak = max(1e-6, max(abs(x) for x in buf))
    frames = bytearray()
    for x in buf:
        v = max(-1.0, min(1.0, x / peak * vol))
        frames += struct.pack("<h", int(v * 32767))
    return bytes(frames)


def write(name: str, data: bytes) -> None:
    path = os.path.join(OUT, name)
    with wave.open(path, "w") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(data)
    print(f"wrote {path} ({len(data)} bytes)")


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    # nuty: (częstotliwość Hz, start s, czas trwania s)
    write("tap.wav", render([(1100, 0.0, 0.05)], 0.06, vol=0.35))
    write("triplet.wav", render([(659, 0.0, 0.12), (988, 0.10, 0.20)], 0.32))
    write("bridge.wav", render([(523, 0.0, 0.12), (784, 0.10, 0.22)], 0.34))
    write(
        "hexagon.wav",
        render(
            [(523, 0.0, 0.12), (659, 0.10, 0.12), (784, 0.20, 0.12), (1047, 0.30, 0.30)],
            0.62,
        ),
    )
    write(
        "win.wav",
        render(
            [(523, 0.0, 0.15), (659, 0.13, 0.15), (784, 0.26, 0.15), (1047, 0.39, 0.42)],
            0.84,
            vol=0.55,
        ),
    )
    write("round_end.wav", render([(440, 0.0, 0.18)], 0.2, vol=0.4))


if __name__ == "__main__":
    main()
