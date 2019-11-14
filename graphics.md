
### Anisotropic Filtering
A method of enhancing the image quality of textures on surfaces of computer graphics that are at oblique viewing angles with respect to the camera where the projection of the texture (not the polygon or other primitive on which it is rendered) appears to be non-orthogona 

### Ambient Occlusion
Ambient occlusion allows you to simulate the soft shadows that occur in the cracks and crevices of your 3D objects when indirect lighting is cast out onto your scene. The soft shadows that are created from ambient occlusion can help to define the separation between objects in your scene and add another level of realism to your render. It’s a subtle effect that makes objects and scenes look less flat, more three dimensional and more realistic.

### Bilinear Filtering
A texture filtering method used to smooth textures when displayed larger or smaller than they actually are.  
Most of the time, when drawing a textured shape on the screen, the texture is not displayed exactly as it is stored, without any distortion. Because of this, most pixels will end up needing to use a point on the texture that is "between" texels – assuming the texels are points (as opposed to, say, squares) – in the middle (or on the upper left corner, or anywhere else; it does not matter, as long as it is consistent) of their respective "cells". Bilinear filtering uses these points to perform bilinear interpolation between the four texels nearest to the point that the pixel represents (in the middle or upper left of the pixel, usually).  

**Trilinear Filtering** is an extension of the bilinear texture filtering method, which also performs linear interpolation between mipmaps. 

Bilinear filtering has several weaknesses that make it an unattractive choice in many cases: using it on a full-detail texture when scaling to a very small size causes accuracy problems from missed texels, and compensating for this by using multiple mipmaps throughout the polygon leads to abrupt changes in blurriness, which is most pronounced in polygons that are steeply angled relative to the camera.  

### Bloom
Bloom is an effect that mimics the inability of cameras to capture bright lights in a scene. It adds light feathers or a haze of light around bright objects. When used well, bloom can provide subtle enhancements that make bright lights, light beams or reflective surfaces appear to pop off the screen. Overuse can wash out images and make them look unnatural.

### Checkerboard rendering
Checkerboard rendering or checkerboarding is a technique that helps lower power processors render high resolution images. It generally involves rendering half of the pixels in each frame in a checkerboard pattern, and inferring the missing pixels from the pixels that were rendered, information from the previous frame, or both. It produces less detailed or fuzzier images than native rendering.

### Chromatic aberration
Bands of false color that appear along edges that separate high contrast light and dark areas of an image. It's a lens flaw that photographers and film makers usually try to eliminate using expensive lenses or digital post-processing. Some developers use it to give their games a film-like quality.

### Downsampling
Downsampling, also known as supersampling, is an anti-aliasing technique. It involves rendering an image at a resolution that is higher than the screen will display. The image is then reduced to the screen’s resolution and the extra pixels are used to smooth curved and diagonal lines. Downsampling also makes textures look sharper and clearer.

### EQAA (Enhanced Quality AA) and CSAA (Coverage Sample AA)
Tries to increase the quality of MSAA. The actual way it does it (increasing the number of coverage-samples while the number of color/depth/stencil-samples remain the same) is complicated, a detailed explenaition can be found here. 

### MLAA (Morphological AA) and FXAA (Fast Aproximate AA)
Post-AA modes that use blur filters. First, it detects contrasts ("edges") in the frame and then blurres it along the gradient. 

This results in higly reduces visible "jaggies" that also coveres alpha-texturs, but it also blurs everything, including textures. It is also the cheapest form of AA and often used in console version of games. 

Personally I dont really like this mode of AA. If you want cheap AA, look at SMAA. 

### MSAA (Multi Sampling AA)
Reduces the performance needed compared to SSAA. MSAA detects the edges of polygons and only increases the number of samples there. 

The main advantage is that it offeres AA that does not blur and uses less performance than SSAA. the disadvantages are that some deferred-rendering engines (like UE3 and most other PS360-era engines) have problems using MSAA and often have subpar results. It also doesnt stop the aliasing of alpha-textures. Some methods like alpha-to-coverage can help smooth alpha textures using MSAA. 

edit: The technical explenation of MSAA was a simplification. A more in-depth explanation can be read here. thanks to /u/fb39ca4 for the english source. 

### SMAA
An AA mode based on the Post-AA blur filter of MLAA (and FXAA). The alisasing "detection" is upgraded and is closer to the detection used in MSAA then the detection used in MLAA and FXAA. The result is that SMAA still remains very cheap, still smoothes alpha-tectures and still greatly reduces the visible "jaggies", but doesnt blur the image as much. 

Personally I think this is one of the best AA modes available. Forcing a slight form of SMAA via driver or tools like RadeonPro or nVidia Inspector combined with traditional MSAA/SSAA will resilt in one of the best results possible. 

 
### TXAA (Temporal AA)
Avery complex form of AA. It is not a post-AA altough it still blurs because of the downsampling method used. The information we have is also vague, so I would like to stop commenting on the technical side here. 

The imlementation of TXAA varies from game to game and version to version of TXAA, so a general statement is hardly possible. What can be said is that it a) uses much more performance than FXAA, MLAA and SMAA, b) the reducement of "jaggies" is one of the best of all AA modes and c) everything blurs. 

Because it often blures much more than MLAA or FXAA it is ihmo not that great of a mode. If the sampling rate used internally for TXAA is upgraded to SSAA (it is based on MSAA) the result can be quite good, but it needs a shit ton of additional performance most rigs dont have. If used on very high resolulutions (4K or higher), it might be acceptable too. Overall a mode that might be more usefull in the future and/or in some special games and/or after some adjustments. 

