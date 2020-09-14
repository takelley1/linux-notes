
### Anisotropic Filtering

A method of enhancing the image quality of textures on surfaces of computer graphics that are at oblique viewing angles
with respect to the camera where the projection of the texture (not the polygon or other primitive on which it is
rendered) appears to be non-orthogonal.

---
### Ambient Occlusion

Allows simulation of the soft shadows that occur in the cracks and crevices of 3D objects when indirect lighting is cast
out onto a scene. The soft shadows that are created from ambient occlusion can help to define the separation between
objects in a scene and add another level of realism to a render. It’s a subtle effect that makes objects and scenes look
less flat, more three dimensional and more realistic.

---
### Bilinear Filtering

A texture filtering method used to smooth textures when displayed larger or smaller than they actually are.
Most of the time, when drawing a textured shape on the screen, the texture is not displayed exactly as it is stored.
Because of this, most pixels will end up needing to use a point on the texture that is "between" texels – assuming the
texels are points (as opposed to, say, squares) – in the middle (or on the upper left corner, or anywhere else; it does
not matter, as long as it is consistent) of their respective "cells." Bilinear filtering uses these points to perform
bilinear interpolation between the four texels nearest to the point that the pixel represents (in the middle or upper
left of the pixel, usually).

**Trilinear Filtering** is an extension of the bilinear texture filtering method, which also performs linear
                        interpolation between mipmaps.

Bilinear filtering has several weaknesses that make it an unattractive choice in many cases: using it on a full-detail
texture when scaling to a very small size causes accuracy problems from missed texels, and compensating for this by
using multiple mipmaps throughout the polygon leads to abrupt changes in blurriness, which is most pronounced in
polygons that are steeply angled relative to the camera.

---
### Bloom

Bloom is an effect that mimics the inability of cameras to capture bright lights in a scene. It adds light feathers or a
haze of light around bright objects. When used well, bloom can provide subtle enhancements that make bright lights,
light beams or reflective surfaces appear to pop off the screen. Overuse can wash out images and make them look
unnatural.

---
### Checkerboard rendering

Checkerboard rendering or checkerboarding is a technique that helps low-power processors render high resolution images.
It generally involves rendering half of the pixels in each frame in a checkerboard pattern, and inferring the missing
pixels from the pixels that were rendered, information from the previous frame, or both. It produces less detailed or
fuzzier images than native rendering.

---
### Chromatic aberration

Bands of false color that appear along edges that separate high contrast light and dark areas of an image. It's a lens
flaw that photographers and film makers usually try to eliminate using expensive lenses or digital post-processing. Some
developers use it to give their games a film-like quality.

---
### Downsampling / Supersampling

Downsampling, also known as supersampling, is an anti-aliasing technique. It involves rendering an image at a resolution
that is higher than the screen will display. The image is then reduced to the screen’s resolution and the extra pixels
are used to smooth curved and diagonal lines. Downsampling also makes textures look sharper and clearer.

---
### EQAA (Enhanced Quality AA) & CSAA (Coverage Sample AA)

Tries to increase the quality of MSAA. The actual way it does it (increasing the number of coverage-samples while the
number of color/depth/stencil-samples remain the same) is complicated.

### MLAA (Morphological AA) & FXAA (Fast Aproximate AA)

Post-AA modes that use blur filters. First, it detects contrasts ("edges") in the frame and then blurres it along the
gradient.

This results in higly reduced visible "jaggies" that covers alpha-texturs, but it also blurs everything, including
textures. It is also the cheapest form of AA computationally and often used in console versions of games.

### MSAA (Multi Sampling AA)

Detects the edges of polygons and only increases the number of samples there.

The main advantage is that it offers AA which doesn't blur and uses less performance than SSAA. the disadvantages are
that some deferred-rendering engines (like UE3 and most other PS360-era engines) have problems using MSAA and often have
subpar results. It also doesn't stop the aliasing of alpha-textures. Some methods like alpha-to-coverage can help smooth
alpha textures using MSAA.

### SMAA

An AA mode based on the Post-AA blur filter of MLAA (and FXAA). The alisasing "detection" is upgraded and is closer to
the detection used in MSAA than the detection used in MLAA and FXAA. The result is that SMAA still remains very cheap,
still smoothes alpha-tectures and still greatly reduces the visible "jaggies."

### TXAA (Temporal AA)

A very complex form of AA. It's not post-AA, though it still blurs because of the downsampling method used. Uses much
more performance than FXAA, MLAA and SMAA. The reduction of "jaggies" is one of the best of all AA modes, but everything
blurs.

If the sampling rate used internally for TXAA is upgraded to SSAA (it is based on MSAA) the result can be quite good.

