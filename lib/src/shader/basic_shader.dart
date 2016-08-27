part of chronosshader;

const String StdVertexBody =
    "gl_Position = ${uPerspectiveViewMatrix} * ${uModelMatrix} * vec4(${aVertexPosition}, 1.0);";

const String NullVertexBody = "gl_Position = vec4(${aVertexPosition}, 1.0);";

List<ShaderObject> createTexturedShader() {
  return [
    new ShaderObject("Textured")
      ..AddAttributeVar(aVertexPosition)
      ..AddUniformVar(uPerspectiveViewMatrix)
      ..AddUniformVar(uModelMatrix)
      ..AddAttributeVar(aTextureCoordinates)
      ..AddVaryingVar(vTextureCoordinates)
      ..SetBodyWithMain(
          [StdVertexBody, "${vTextureCoordinates} = ${aTextureCoordinates};"]),
    new ShaderObject("TexturedF")
      ..AddVaryingVar(vTextureCoordinates)
      ..AddUniformVar(uColor)
      ..AddUniformVar(uTextureSampler)
      ..SetBodyWithMain([
        "gl_FragColor = texture2D(${uTextureSampler}, ${vTextureCoordinates}) + vec4( ${uColor}, 0.0 );"
      ])
  ];
}

List<ShaderObject> createSolidColorShader() {
  return [
    new ShaderObject("SolidColor")
      ..AddAttributeVar(aVertexPosition)
      ..AddUniformVar(uPerspectiveViewMatrix)
      ..AddUniformVar(uModelMatrix)
      ..SetBodyWithMain([StdVertexBody]),
    new ShaderObject("SolidColorF")
      ..AddUniformVar(uColor)
      ..SetBodyWithMain(["gl_FragColor = vec4( ${uColor}, 1.0 );"])
  ];
}

List<ShaderObject> createColorShader() {
  return [
    new ShaderObject("Color")
      ..AddAttributeVar(aVertexPosition)
      ..AddUniformVar(uPerspectiveViewMatrix)
      ..AddUniformVar(uModelMatrix)
      ..AddAttributeVar(aColors)
      ..AddVaryingVar(vColors)
      ..SetBodyWithMain([StdVertexBody, "${vColors} = ${aColors};"]),
    new ShaderObject("ColorF")
      ..AddVaryingVar(vColors)
      ..SetBodyWithMain(["gl_FragColor = vec4( ${vColors}, 1.0 );"])
  ];
}


final String _lightHelpers = """
struct LightIntensity {
    float diffuse;
    float specular;
    float attenuation;
};

struct LightSourceInfo {
    vec3 pos;      // for spot and point
    vec3 dir;      // for spot and dir light
    vec3 diffuseColor;
    vec3 specularColor;
    float type;
    float range;        // for spot and point
    float spotCutoff;   // for spot
    float spotFocus;    // for spot
    float glossiness;   // Oddball: this comes from the material
};

// This needs to stay in sync woth Light::PackInfo
LightSourceInfo UnpackLightSourceInfo(mat4 m, float glossiness) {
  LightSourceInfo info;
  info.pos = m[0].xyz;
  info.dir = normalize(m[1].xyz);
  info.diffuseColor = m[2].xyz;
  info.specularColor = m[3].xyz;
  info.type = m[0].a;
  info.range = m[1].a;
  info.spotCutoff = m[2].a;
  info.spotFocus = m[3].a;
  info.glossiness = glossiness;
  return info;
}

float GetDiffuse(vec3 lightDir, vec3 normal) {
  return max(dot(normal, lightDir), 0.0);
}

float GetSpecular(vec3 lightDir, vec3 viewDir, vec3 normal, float glossiness) {
  vec3 angleW = normalize(viewDir + lightDir);
  float specComp = max(0., dot(normal, angleW));
  return pow(specComp, max(1.0, glossiness));
}

void GetDiffuseAndSpecularFactors(LightSourceInfo info,
                                  vec3 vertexPos,
                                  vec3 vertexNormal,
                                  vec3 eyePos,
                                  out float diffuseFactor,
                                  out float specularFactor) {
    if (info.type == 5.0) {
        // ================= directional light
        diffuseFactor = GetDiffuse(info.dir, vertexNormal);
        specularFactor = GetSpecular(info.dir, normalize(eyePos - vertexPos),
                                     vertexNormal, info.glossiness);
    } else if (info.type == 3.0) {
        // ================= point light
        vec3 lightDir = info.pos - vertexPos;
        float attenuation = max(0.0, 1.0 - length(lightDir) / info.range);
        vec3 lightDirNorm = normalize(lightDir);
        vec3 viewDirNorm = normalize(eyePos - vertexPos);
        diffuseFactor = attenuation * GetDiffuse(lightDirNorm, vertexNormal);
        specularFactor = attenuation * GetSpecular(lightDirNorm, viewDirNorm,
                                                   vertexNormal, info.glossiness);
    } else if (info.type == 2.0) {
        // ================= spot light
        vec3 spotDir = normalize(info.pos - vertexPos);
        vec3 lightDirNorm = normalize(info.dir);
        float cosAngle = max(0., dot(lightDirNorm, spotDir));
	      if (cosAngle < info.spotCutoff) {
            diffuseFactor = 0.0;
            specularFactor = 0.0;
        } else {
            cosAngle = max(0.0, pow(cosAngle, info.spotFocus));
	          float attenuation = max(0.0, 1.0 - length(spotDir) / info.range) * cosAngle;
	          vec3 viewDirNorm = normalize(eyePos - vertexPos);
            diffuseFactor = attenuation * GetDiffuse(lightDirNorm, vertexNormal);
            specularFactor = attenuation * GetSpecular(lightDirNorm, viewDirNorm,
                                                       vertexNormal, info.glossiness);
        }
    } else {
        diffuseFactor = 0.0;
        specularFactor = 0.0;
    }
}
""";



//  Gouraud shading - most action happens in vertext shader - cheaper

// Phong shader - most action happens in fragment shader - expensive
// Light Matrix m organization:
// m[0].xyz light direction
//
List<ShaderObject> createLightShaderBlinnPhong() {
  return [
    new ShaderObject("Light")
      ..AddAttributeVar(aVertexPosition)
      ..AddAttributeVar(aNormal)
      ..AddVaryingVar(vVertexPosition)
      ..AddVaryingVar(vNormal)
      ..AddUniformVar(uPerspectiveViewMatrix)
      ..AddUniformVar(uModelMatrix)
      ..AddUniformVar(uNormalMatrix)
      ..SetBodyWithMain([
        """
        vec4 pos = ${uModelMatrix} * vec4(${aVertexPosition}, 1.0);
        gl_Position = ${uPerspectiveViewMatrix} * pos;
        ${vVertexPosition} = pos.xyz;
        ${vNormal} = (${uModelMatrix} * vec4(${aNormal}, 0.0)).xyz;
        // ${vNormal} = ${uNormalMatrix} * ${aNormal};
        """
      ]),
    new ShaderObject("LightF")
      ..AddVaryingVar(vNormal)
      ..AddVaryingVar(vVertexPosition)
      ..AddUniformVar(uLightSourceInfo0)
      ..AddUniformVar(uEyePosition)
      ..SetBody([_lightHelpers,
        """
      void main() {
        LightSourceInfo info =  UnpackLightSourceInfo(${uLightSourceInfo0}, 10.0);
        float diffuseFactor = 0.0;
        float specularFactor = 0.0;
        GetDiffuseAndSpecularFactors(info,
                                     ${vVertexPosition},
                                     ${vNormal},
                                     ${uEyePosition},
                                     diffuseFactor, specularFactor);

         gl_FragColor = vec4(diffuseFactor * info.diffuseColor +
                             specularFactor * info.specularColor, 1.0 );
      }
      """
      ])
  ];
}

List<ShaderObject> createNormal2ColorShader() {
  return [
    new ShaderObject("Normal2Color")
      ..AddAttributeVar(aVertexPosition)
      ..AddAttributeVar(aNormal)
      ..AddVaryingVar(vColors)
      ..AddUniformVar(uPerspectiveViewMatrix)
      ..AddUniformVar(uModelMatrix)
      ..SetBodyWithMain([
        StdVertexBody,
        "vColors = normalize(${aNormal} / 2.0 + vec3(0.5) );"
      ]),
    new ShaderObject("Normal2ColorF")
      ..AddVaryingVar(vColors)
      ..SetBodyWithMain(["gl_FragColor = vec4( ${vColors}, 1.0 );"])
  ];
}

// this shader works well for cube shapes, for other shapes it might be better to use the normals attribute to sample the cube texture
List<ShaderObject> createCubeMapShader() {
  return [
    new ShaderObject("CubeMap")
      ..AddAttributeVar(aVertexPosition)
      ..AddVaryingVar(vVertexPosition)
      ..AddUniformVar(uPerspectiveViewMatrix)
      ..AddUniformVar(uModelMatrix)
      ..SetBodyWithMain([
        StdVertexBody,
        "${vVertexPosition} = normalize(${aVertexPosition});"
      ]),
    new ShaderObject("CubeMapF")
      ..AddVaryingVar(vVertexPosition)
      ..AddUniformVar(uTextureCubeSampler)
      ..SetBodyWithMain([
        "gl_FragColor = textureCube( ${uTextureCubeSampler}, ${vVertexPosition} );"
      ]),
  ];
}

List<ShaderObject> createPointSpritesShader() {
  return [
    new ShaderObject("PointSprites")
      ..AddAttributeVar(aVertexPosition)
      ..AddUniformVar(uPerspectiveViewMatrix)
      ..AddUniformVar(uModelMatrix)
      ..AddUniformVar(uPointSize)
      ..SetBodyWithMain(
          [StdVertexBody, "gl_PointSize = ${uPointSize}/gl_Position.z;"]),
    new ShaderObject("PointSpritesF")
      ..AddUniformVar(uTextureSampler)
      ..SetBodyWithMain(
          ["gl_FragColor = texture2D( ${uTextureSampler},  gl_PointCoord);"])
  ];
}
