#ifndef UTILS_CGINC
#define UTILS_CGINC

    #define TWO_PI 6.28318530718

    float3 TriColAmbient(float3 n, float3 uCol, float3 dCol, float3 sCol, float weakness) {
        float upMask = max(0.0, n.y);
        float downMask = max(0.0, -n.y);
        float sideMask  = 1 - upMask - downMask;
        float3 envCol = uCol * upMask + dCol * downMask + sCol * sideMask;
        envCol = lerp(envCol, float3(1, 1, 1), weakness);
        return envCol;
    }

    void Translation(inout float3 pos, float3 translation) {
        pos += translation;
    }

    void Oscillate(inout float3 pos, float amplitude, float frequency, float phase) {
        pos += amplitude * sin(frequency * _Time.y * TWO_PI + phase);
    }

    void Rotation(inout float3 pos, float3 rotation) {
        float3x3 rotMat = float3x3(
            cos(rotation.y) * cos(rotation.z), cos(rotation.y) * sin(rotation.z), -sin(rotation.y),
            cos(rotation.x) * sin(rotation.z) + sin(rotation.x) * sin(rotation.y) * cos(rotation.z), cos(rotation.x) * cos(rotation.z) - sin(rotation.x) * sin(rotation.y) * sin(rotation.z), sin(rotation.x) * cos(rotation.y),
            sin(rotation.x) * sin(rotation.z) - cos(rotation.x) * sin(rotation.y) * cos(rotation.z), sin(rotation.x) * cos(rotation.z) + cos(rotation.x) * sin(rotation.y) * sin(rotation.z), cos(rotation.x) * cos(rotation.y)
        );
        pos = mul(rotMat, pos);
    }

    void Scale(inout float3 pos, float3 scale) {
        pos *= scale;
    }

    

#endif