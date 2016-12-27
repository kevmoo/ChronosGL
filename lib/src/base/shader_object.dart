part of base;

class ShaderVarDesc {
  String type;
  String purpose = "";

  ShaderVarDesc(this.type, this.purpose);

  int GetSize() {
    switch (type) {
      case "float":
        return 1;
      case "vec2":
        return 2;
      case "vec3":
        return 3;
      case "vec4":
        return 4;
      default:
        assert(false);
        return -1;
    }
  }

  bool IsScalarTypeFloat() {
    switch (type) {
      case "float":
      case "vec2":
      case "vec3":
      case "vec4":
        return true;
      default:
        return false;
    }
  }
}

// Used both as enum and as string. The latter allows for a limited form
// of syntax checking inside shader programs.
const int prefixElement = 0x65; // 'e';
const String eArray = "eArray"; // element array
// ===========================================================
// Misc Controls
// ===========================================================
const int prefixControl = 0x63; // 'c;

const String cDepthTest = "cDepthTest";
const String cDepthWrite = "cDepthWrite";
const String cBlend = "cBlend";
const String cBlendEquation = "cBlendEquation";
const String cNumItems = "cNumItems";
const String cNumInstances = "cNumInstances";
const String cDrawMode = "cDrawMode";
// ===========================================================
// Attributes
// ===========================================================
const int prefixAttribute = 0x61; // 'a';

const String aColors = "aColors";
const String aColorAlpha = "aColorAlpha";
const String aVertexPosition = "aVertexPosition";
const String aTextureCoordinates = "aTextureCoordinates";
const String aNormal = "aNormal";
const String aBinormal = "aBinormal";
const String aCenter = "aCenter";
const String aPointSize = "aPointSize";

// ===========================================================
// Instancer
// ===========================================================
const int prefixInstancer = 0x69; // 'i';

const String iaRotation = "iaRotation";
const String iaTranslation = "iaTranslation";
const String iaScale = "iaScale";

// ===========================================================
// Varying
// ===========================================================
const String vColors = "vColors";
const String vTextureCoordinates = "vTextureCoordinates";
const String vLightWeighting = "vLightWeighting";
const String vNormal = "vNormal";
const String vVertexPosition = "vVertexPosition";
const String vCenter = "vCenter";
const String vPositionFromLight0 = "vPositionFromLight0";

// ===========================================================
// Uniform
// ===========================================================
const int prefixUniform = 0x75; // 'u';

const String uTransformationMatrix = "uTransformationMatrix";
//const String uModelViewMatrix = "uModelViewMatrix";
//const String uViewMatrix = "uViewMatrix";
const String uNormalMatrix = "uNormalMatrix";

const String uPerspectiveViewMatrix = "uPerspectiveViewMatrix";
const String uLightPerspectiveViewMatrix = "uLightPerspectiveViewMatrix";
const String uLightPerspectiveViewMatrix0 = uLightPerspectiveViewMatrix + "0";

const String uModelMatrix = "uModelMatrix";

const String uShadowSampler0 = "uShadowSampler0";

const String uTextureSampler = "uTextureSampler";
const String uTextureCubeSampler = "uTextureCubeSampler";
const String uTexture2Sampler = "uTexture2Sampler";
const String uTexture3Sampler = "uTexture3Sampler";
const String uTexture4Sampler = "uTexture4Sampler";
const String uTime = "uTime";
const String uColor = "uColor";
const String uColorAlpha2 = "uColorAlpha2";
const String uColorAlpha = "uColorAlpha";
const String uCameraNear = "uCameraNear";
const String uCameraFar = "uCameraFar";
const String uCanvasSize = "uCanvasSize";
const String uPointSize = "uPointSize";
const String uFogNear = "uFogNear";
const String uFogFar = "uFogFar";
const String uEyePosition = "uEyePosition";

const String uMaterial = "uMaterial";
const String uLightSourceInfo = "uLightSourceInfo";
const String uLightSourceInfo0 = uLightSourceInfo + "0";
const String uLightSourceInfo1 = uLightSourceInfo + "1";
const String uLightSourceInfo2 = uLightSourceInfo + "2";
const String uLightSourceInfo3 = uLightSourceInfo + "3";

Map<String, ShaderVarDesc> _VarsDb = {
  eArray: new ShaderVarDesc("index", ""),

  //
  cBlend: new ShaderVarDesc("", ""),
  cBlendEquation: new ShaderVarDesc("", ""),
  cDepthWrite: new ShaderVarDesc("", ""),
  cDepthTest: new ShaderVarDesc("", ""),
  cNumItems: new ShaderVarDesc("", ""),
  cNumInstances: new ShaderVarDesc("", ""),
  cDrawMode: new ShaderVarDesc("", ""),

  // attribute vars
  // This should also contain an alpha channel
  aColors: new ShaderVarDesc("vec3", "per vertex color"),
  aColorAlpha: new ShaderVarDesc("vec4", "per vertex color"),
  aVertexPosition: new ShaderVarDesc("vec3", "vertex coordinates"),
  aTextureCoordinates: new ShaderVarDesc("vec2", "texture uvs"),
  aNormal: new ShaderVarDesc("vec3", "vertex normals"),
  aBinormal: new ShaderVarDesc("vec3", "vertex binormals"),
  aCenter: new ShaderVarDesc("vec4", "for wireframe"),
  aPointSize: new ShaderVarDesc("float", ""),

  iaRotation: new ShaderVarDesc("vec4", ""),
  iaTranslation: new ShaderVarDesc("vec3", ""),
  iaScale: new ShaderVarDesc("vec3", ""),

  // Varying
  vColors: new ShaderVarDesc("vec3", "per vertex color"),
  vTextureCoordinates: new ShaderVarDesc("vec2", ""),
  vLightWeighting: new ShaderVarDesc("vec3", ""),
  vNormal: new ShaderVarDesc("vec3", ""),
  vVertexPosition: new ShaderVarDesc("vec3", "vertex coordinates"),
  vPositionFromLight0: new ShaderVarDesc("vec4", "delta from light"),
  vCenter: new ShaderVarDesc("vec4", "for wireframe"),

  // uniform vars
  uTransformationMatrix: new ShaderVarDesc("mat4", ""),
  //uModelViewMatrix: new ShaderVarDesc("mat4", ""),
  uModelMatrix: new ShaderVarDesc("mat4", ""),
  //uViewMatrix: new ShaderVarDesc("mat4", ""),
  uNormalMatrix: new ShaderVarDesc("mat3", ""),
  //uPerspectiveMatrix: new ShaderVarDesc("mat4", ""),
  uPerspectiveViewMatrix: new ShaderVarDesc("mat4", ""),
  uLightPerspectiveViewMatrix0: new ShaderVarDesc("mat4", ""),

  uShadowSampler0: new ShaderVarDesc("sampler2D", ""),

  uTextureSampler: new ShaderVarDesc("sampler2D", ""),
  uTexture2Sampler: new ShaderVarDesc("sampler2D", ""),
  uTexture3Sampler: new ShaderVarDesc("sampler2D", ""),
  uTexture4Sampler: new ShaderVarDesc("sampler2D", ""),
  uTextureCubeSampler: new ShaderVarDesc("samplerCube", ""),
  uTime: new ShaderVarDesc("float", "time since program start in sec"),
  uCameraNear: new ShaderVarDesc("float", ""),
  uCameraFar: new ShaderVarDesc("float", ""),
  uFogNear: new ShaderVarDesc("float", ""),
  uFogFar: new ShaderVarDesc("float", ""),
  uPointSize: new ShaderVarDesc("float", ""),
  uCanvasSize: new ShaderVarDesc("vec2", ""),
  uColor: new ShaderVarDesc("vec3", ""),
  uColorAlpha: new ShaderVarDesc("vec4", ""),
  uColorAlpha2: new ShaderVarDesc("vec4", ""),
  uEyePosition: new ShaderVarDesc("vec3", ""),
  uMaterial: new ShaderVarDesc("mat4", ""),
  uLightSourceInfo0: new ShaderVarDesc("mat4", ""),
  uLightSourceInfo1: new ShaderVarDesc("mat4", ""),
  uLightSourceInfo2: new ShaderVarDesc("mat4", ""),
  uLightSourceInfo3: new ShaderVarDesc("mat4", ""),
};

void IntroduceNewShaderVar(String canonical, ShaderVarDesc desc) {
  assert(!_VarsDb.containsKey(canonical));
  _VarsDb[canonical] = desc;
}

ShaderVarDesc RetrieveShaderVarDesc(String canonical) {
  return _VarsDb[canonical];
}

// ShaderObject describes a shader (either fragment or vertex) and its
// interface to the world on a syntactical (uncompiled) level.
// Protocol:
// SetBody(WithMain) must be called last;
class ShaderObject {
  String name;
  String shader;

  Map<String, String> attributeVars = {};
  Map<String, String> uniformVars = {};
  Map<String, String> varyingVars = {};

  ShaderObject(this.name);

  void AddAttributeVar(String canonicalName, [String actualName = null]) {
    assert(shader == null);
    assert(_VarsDb.containsKey(canonicalName));
    assert(!attributeVars.containsKey(canonicalName));
    if (actualName == null) actualName = canonicalName;
    attributeVars[canonicalName] = actualName;
  }

  void AddAttributeVars(List<String> names) {
    assert(shader == null);

    for (String n in names) {
      assert(_VarsDb.containsKey(n));
      assert(!attributeVars.containsKey(n));
      attributeVars[n] = n;
    }
  }

  void AddUniformVar(String canonicalName, [String actualName = null]) {
    assert(shader == null);
    assert(_VarsDb.containsKey(canonicalName));
    assert(!uniformVars.containsKey(canonicalName));
    if (actualName == null) actualName = canonicalName;
    uniformVars[canonicalName] = actualName;
  }

  void AddUniformVars(List<String> names) {
    assert(shader == null);

    for (String n in names) {
      assert(_VarsDb.containsKey(n));
      assert(!uniformVars.containsKey(n));
      uniformVars[n] = n;
    }
  }

  void AddVaryingVar(String canonicalName, [String actualName = null]) {
    assert(shader == null);
    assert(_VarsDb.containsKey(canonicalName));
    assert(!varyingVars.containsKey(canonicalName));
    if (actualName == null) actualName = canonicalName;
    varyingVars[canonicalName] = actualName;
  }

  void AddVaryingVars(List<String> names) {
    assert(shader == null);

    for (String n in names) {
      assert(_VarsDb.containsKey(n));
      assert(!varyingVars.containsKey(n));
      varyingVars[n] = n;
    }
  }

  void SetBodyWithMain(List<String> body) {
    assert(shader == null);
    shader = _CreateShader(true, body);
  }

  void SetBody(List<String> body) {
    assert(shader == null);
    shader = _CreateShader(false, body);
  }

  // InitializeShader updates the shader field from header and body.
  // If you have set shader manually do not call this.
  String _CreateShader(bool addWrapperForMain, List<String> body) {
    assert(shader == null);
    List<String> out = [];
    out.add("precision highp float;");
    out.add("");
    for (String v in attributeVars.keys) {
      ShaderVarDesc d = _VarsDb[v];
      out.add("attribute ${d.type} ${attributeVars[v]};");
    }
    out.add("");
    for (String v in varyingVars.keys) {
      ShaderVarDesc d = _VarsDb[v];
      out.add("varying ${d.type} ${varyingVars[v]};");
    }
    out.add("");
    for (String v in uniformVars.keys) {
      ShaderVarDesc d = _VarsDb[v];
      out.add("uniform ${d.type} ${uniformVars[v]};");
    }
    out.add("");

    if (addWrapperForMain) {
      out.add("void main(void) {");
    }
    out.addAll(body);
    if (addWrapperForMain) {
      out.add("}");
    }

    return out.join("\n");
  }
}