#ifndef UTILS_CGINC
#define UTILS_CGINC

    float3 TriColAmbient(float3 n, float3 uCol, float3 dCol, float3 sCol, float weakness) {
        float upMask = max(0.0, n.y);
        float downMask = max(0.0, -n.y);
        float sideMask  = 1 - upMask - downMask;
        float3 envCol = uCol * upMask + dCol * downMask + sCol * sideMask;
        envCol = lerp(envCol, float3(1, 1, 1), weakness);
        return envCol;
    }

#endif