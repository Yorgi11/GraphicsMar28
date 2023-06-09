# GraphicsMar28
 
Task 1:
Public repo created with unity gitignore, and empty 3D unity scene,and a build of the project

Task2:
Deffered vs Forward Rendering

Forward Rendering:
In forward rendering, each object in the scene is rendered by directly calculating its shading and blending it with the final image. This process is repeated for every light source affecting the object. The main steps are:
Clear the framebuffer.
For each object in the scene, we render the object with the current light's contribution. Then we blend the object's shaded result with the framebuffer.

<img width="272" alt="image" src="https://user-images.githubusercontent.com/94036650/228292830-a2e697ad-098f-4ba6-9b7c-899c698a2aec.png">

Deferred Rendering:
In deferred rendering, shading calculations are deferred until the end of the rendering pipeline. Geometry and material information are first rendered into separate buffers called G-buffers. Then, a second pass computes the shading using the information stored in the G-buffers. The main steps are:

Clear the G-buffers.
For each object in the scene, we render the object's geometry and material information into the G-buffers.
Clear the framebuffer.
For each light in the scene, we render the light's contribution using the G-buffers.
Blend the light's shaded result with the framebuffer.

<img width="272" alt="Screenshot 2023-03-28 124931" src="https://user-images.githubusercontent.com/94036650/228311613-a46cd10c-94f7-49aa-8c98-7daffd671ae2.png">


The key difference is that deferred rendering separates geometry rendering and shading calculations into two separate passes, which can improve performance for scenes with many lights.

Task 3:
build for this task located at Build/Build1
Create a toon shaded square-shapedwave.
<img width="551" alt="Screenshot 2023-03-28 121626" src="https://user-images.githubusercontent.com/94036650/228308739-b3b4de35-0840-4cb5-beea-ee9899e7d398.png">
<img width="620" alt="Screenshot 2023-03-28 160731" src="https://user-images.githubusercontent.com/94036650/228356140-d96dbbc9-2020-44d3-a0a9-67e48d4f0e58.png">

The toon shader is separated into two main parts;
the surface shader for the toon shading effect and the outline pass for creating the outline.

Surface shader for toon shading effect;
The shader starts with tags to define the render type and queue. "RenderType" = "Opaque" means that this shader is meant for opaque materials, and "Queue" = "Geometry" sets the rendering order for the shader.
A surface shader named surf and the custom lighting model LightingToonRamp are added.
The properties _Color, _ShadowColor, _ShadowVal, _RampTex, and _MainTex, are defined as input properties for the shader.
The LightingToonRamp function calculates the shading by using a ramp texture (_RampTex). The lighting model blends the object's albedo color and shadow color based on the lighting intensity and shadow attenuation.
The surf function is implemented to output the object's albedo using the _MainTex and _Color properties.

Outline pass;
The outline pass is defined as a separate pass. The face culling mode is set to Cull Front, which means that only the backfaces of the model will be rendered in this pass.
The outline pass has a vertex shader (vert) and a fragment shader (frag) to create the outline effect.
The vertex shader takes the input vertex data and calculates the outline by offsetting the vertex position along the view direction and multiplying it by the _Thickness property. The resulting color of the outline is set by the _OutColor property.
The fragment shader simply outputs the color of the outline that was calculated in the vertex shader.

The wave shader
a simple if statement that determines if the value from the sin function is below 0.5. If it is below 0.5 then the height gets set to -1, if not then the height gets set to 1. This creates the effect of square waves with a sufficiently high amplitude.

Task 4:
Explain the code snipet:
The effect downscales the source texture iteratively, blurring it, and then upscales it back to the original size.
first we calculate the width and height of the downscaled texture based on the source texture dimensions and an integerRange variable. 
The downscaled dimensions are obtained by dividing the source dimensions by integerRange.
We store the source texture format in the format variable.
Then create an array of RenderTextures named textures with a size of 16. This array will hold the temporary textures created during the downscaling and upscaling process.
now we create a temporary RenderTexture named currentDestination and initialize it with the downscaled width, height, and format. Blit the source texture to this temporary texture.
Next we create a new RenderTexture named currentSource and assign the currentDestination texture to it.
Blit the currentSource texture to the final destination texture.
Release the temporary currentSource texture, as it's no longer needed.
Iterate through the downscaling process. For each iteration, halve the width and height, create a new temporary RenderTexture, and blit the previous texture onto it. Repeat this process until the height is less than 2 or the maximum number of iterations is reached.
Iterate through the upscaling process. For each iteration, blit the previous texture onto the next texture in the textures array. Release the temporary texture after each iteration, as it's no longer needed.
Finally, blit the currentSource texture onto the destination texture

Task 5:
No change from the screen shots in Task 3. Toon shader already has outlines implemented. Wave shader already does vertex extrusion
<img width="551" alt="Screenshot 2023-03-28 121626" src="https://user-images.githubusercontent.com/94036650/228308790-526e41de-9613-4d4d-a6be-e89925d7ad93.png">
<img width="620" alt="Screenshot 2023-03-28 160731" src="https://user-images.githubusercontent.com/94036650/228356087-0af9d145-87e9-4bcb-9e7b-0715df049d97.png">

Task 6:
Explain the code snipet:
This is a shader that creates a custom lighting effect with colored shadows.

Fist we define the Properties;
_Color: Main color of the material.
_MainTex: Base texture (RGB) of the material.
_ShadowColor: Color of the shadows.

The subshader is defined with a "RenderType" = "Opaque" tag, which indicates it is intended for opaque materials.
The LOD value is set to 200, which determines the shader's level of detail.

The shader program is declared with a #pragma directive that defines a surface shader named surf and uses the custom lighting model LightingCSLambert.
The _MainTex, _Color, and _ShadowColor properties are declared as sampler2D and fixed4 data types.
The Input struct is defined, which contains the texture coordinates for the _MainTex.

The LightingCSLambert function is the custom lighting model that calculates the lighting and shadow colors based on the Lambert model.
The diffuse lighting is calculated using the dot product of the surface normal and the light direction.
The shadow color is calculated using the attenuation value, which determines the intensity of the shadows.

The surf function takes the input texture coordinates and calculates the final albedo and alpha values for the material.
The albedo color is obtained by multiplying the _MainTex and _Color properties.
The alpha value is taken directly from the input texture.

Finally if the shader is not supported on the target platform, the shader will fall back to the built-in "Diffuse" shader.


Task 7:
build for this task located at Build/Build2
Glass shader:
The shader simulates the appearance of glass by combining refraction, normal mapping, and a texture to tint the final result.

Fist we define the Properties:
_MainTex: The main texture that tints the final output color.
_BumpMap: The normal map texture that simulates surface details and affects the refraction.
_ScaleUV: A scalar value that controls the intensity of the refraction effect.

GrabPass: The GrabPass captures the current screen content into a temporary texture called _GrabTexture. This texture is used later in the shader to create the refraction effect.

The shader has a single pass, containing two functions - the vertex shader (vert) and the fragment shader (frag).

Vertex shader (vert): The vertex shader takes the input vertex data (appdata) and transforms it into clip space using UnityObjectToClipPos. It then calculates UV coordinates for the _GrabTexture, taking into account if Unity uses UV coordinates starting from the top-left or bottom-left corner. It also calculates the UV coordinates for both the _MainTex and the _BumpMap.

Fragment shader (frag): The fragment shader is responsible for the final output color of each pixel. It first unpacks the normal value from the _BumpMap and calculates an offset value for the _GrabTexture UVs based on the normal value and the _ScaleUV property. The offset is then applied to the _GrabTexture UVs to create the refraction effect. The refraction is combined with the main texture (_MainTex) to tint the final output color.

Diagram
![Screenshot 2023-03-28 165955](https://user-images.githubusercontent.com/94036650/228365647-ab0d6a71-5126-4810-b485-c7a6c58ed569.png)

This shader can be used to create a stained glass look and/or to add a level of depth to any semi transparent effects, like adding ui and having the Ui have various levels of transparency based on the texture you provide the shader
