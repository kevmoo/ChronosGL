import 'package:chronosgl/chronosgl.dart';

void main() {
  
  ChronosGL chronosGL = new ChronosGL('#webgl-canvas', useFramebuffer:false, fxShader: createPlasmaShader3());

  ShaderProgram prg = chronosGL.createProgram(createPlasmaShader());

  Camera camera = chronosGL.getCamera();
  
  camera.setPos( 0.0, 0.0, 56.0 );
    
  FlyingCamera fc = new FlyingCamera(camera); // W,A,S,D keys fly
  chronosGL.addAnimatable('flyingCamera', fc);
    
  MeshData md = chronosGL.getUtils().createCube();
  for( int i=0; i<md.vertices.length;i++) {
    md.vertices[i] = md.vertices[i]*10;
  }
  Mesh m = md.createMesh();
  m.setPos(0.0, 0.0, -150.0);
  m.lookUp(1.0);
  m.lookLeft(0.7);
  
   m.setAnimateCallback((Node node, double time){
       m.rollLeft(time*0.0001);
       m.lookLeft(time*0.0001);
   });
  
  prg.add(m);
  chronosGL.run();
}
