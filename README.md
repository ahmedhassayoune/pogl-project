# POGL - Cellular automatons

This project is led by [@oscarmorand](https://github.com/oscarmorand) and [@ahmedhassayoune](https://github.com/ahmedhassayoune) at french software engineering school EPITA.
It is a Shadertoy implementation of [cellular automatons](https://en.wikipedia.org/wiki/Cellular_automaton) (1D Rules, 2D Rules, game of life, Smooth Life, Lenia).

# How to run the shaders

To run the shaders, you can install the vscode extension [Shader Toy](https://marketplace.visualstudio.com/items?itemName=stevensona.shader-toy) by *Adam Stevenson*. You can then open the different shaders in the `src` folder and run them `Ctrl+Shift+P` -> `Shader Toy: Show GLSL Preview`.

These shaders are also available online on [Shadertoy](https://www.shadertoy.com). You can find the links to the online shaders in the list below.

### Note
The shaders with multiple files `*_1, *_2, *_3` represent the same shader and need to be launched from the first shader `*_1`.

# Shaders list
**🚨 Warning: Some shaders may be harmful to people with photosensitive epilepsy!**

## 1D Shaders
With these shaders, you can play with the `gen_nb_frames` parameter to slow down the time, the `isRandom` boolean parameter to switch between single-cell initialisation or random initialisation. For the random one, you can change the `density` parameter to play with the number of cells.
- Rule 90 [online shader](https://www.shadertoy.com/view/4cXcz8) ([wiki](https://en.wikipedia.org/wiki/Rule_90))
- Rule 110 [online shader](https://www.shadertoy.com/view/XcXcz8) ([wiki](https://en.wikipedia.org/wiki/Rule_110))
- Rule 184 [online shader](https://www.shadertoy.com/view/4cfcz8) ([wiki](https://en.wikipedia.org/wiki/Rule_184))

<div style="text-align: center; margin-top: 20px">
  <figure style="display: inline-block; margin-right: 10px;">
    <img src="gifs/rule_90.gif" style="width: 280px; height: 280px;" alt="Rule 90">
  </figure>
  <figure style="display: inline-block; margin-right: 10px;">
    <img src="gifs/rule_110.gif" style="width: 280px; height: 280px;" alt="Rule 110">
  </figure>
  <figure style="display: inline-block;">
    <img src="gifs/rule_184.gif" style="width: 280px; height: 280px;" alt="Rule 184">
  </figure>
</div>

## 2D Basic Shaders

With these shaders, you can play with the `gen_nb_frames` parameter to slow down the time and `scale` parameter to zoom in. You can also interact with them by clicking with your mouse on the rendering screen. Each one of them has their own parameters you can play with to change the simulation sequence.
- Belooussov-Jabotinski reaction [online shader](https://www.shadertoy.com/view/MflyDn) ([wiki](https://en.wikipedia.org/wiki/Belousov%E2%80%93Zhabotinsky_reaction))
- Viral Replication [online shader](https://www.shadertoy.com/view/XcfyW8) ([doc](https://www.hermetic.ch/pca/vr.htm))
- Game of life [online shader](https://www.shadertoy.com/view/lXyXzG) ([wiki](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life))

<div style="text-align: center; margin-top: 20px">
  <figure style="display: inline-block; margin-right: 10px;">
    <img src="gifs/belousov_zhabotinsky.gif" style="width: 280px; height: 280px;" alt="Belooussov-Jabotinski reaction">
  </figure>
  <figure style="display: inline-block; margin-right: 10px;">
    <img src="gifs/viral_replication.gif" style="width: 280px; height: 280px;" alt="Viral Replication">
  </figure>
  <figure style="display: inline-block;">
    <img src="gifs/gol.gif" style="width: 280px; height: 280px;" alt="Game of life">
  </figure>
</div>

## Smooth Life
- Smooth Life discrete time-stepping [online shader](https://www.shadertoy.com/view/XcscW7)
- Smooth Life continuous time-stepping [online shader](https://www.shadertoy.com/view/4clyD7)
- Gaussian Smooth Life [online shader](https://www.shadertoy.com/view/XflcD7)

<div style="text-align: center; margin-top: 20px">
  <figure style="display: inline-block; margin-right: 10px;">
    <img src="gifs/smooth_life_discrete.gif" style="width: 280px; height: 280px;" alt="Smooth Life discrete time-stepping">
  </figure>
  <figure style="display: inline-block; margin-right: 10px;">
    <img src="gifs/smooth_life.gif" style="width: 280px; height: 280px;" alt="Smooth Life continuous time-stepping">
  </figure>
  <figure style="display: inline-block;">
    <img src="gifs/gaussian_smooth_life.gif" style="width: 280px; height: 280px;" alt="Gaussian Smooth Life">
  </figure>
</div>

- Smooth Life color 1 [online shader](https://www.shadertoy.com/view/4flyD7)
- Smooth Life color 2 [online shader](https://www.shadertoy.com/view/XcsyD7)

<div style="text-align: center; margin: 20px 0;">
  <figure style="display: inline-block; margin-right: 10px;">
    <img src="gifs/smooth_life_color1.gif" style="width: 280px; height: 280px;" alt="Smooth Life color 1">
  </figure>
  <figure style="display: inline-block;">
    <img src="gifs/smooth_life_color2.gif" style="width: 280px; height: 280px;" alt="Smooth Life color 2">
  </figure>
</div>

- Smooth Life optimized [online shader](https://www.shadertoy.com/view/XclcD7)
- Optimized Gaussian Smooth Life [online shader](https://www.shadertoy.com/view/4fscD7)

<div style="text-align: center; margin: 20px 0;">
  <figure style="display: inline-block; margin-right: 10px;">
    <img src="gifs/smooth_life_opti.gif" style="width: 280px; height: 280px;" alt="Smooth Life optimized">
  </figure>
  <figure style="display: inline-block;">
    <img src="gifs/gaussian_smooth_life_opti.gif" style="width: 280px; height: 280px;" alt="Optimized Gaussian Smooth Life">
  </figure>
</div>

## Lenia
- Lenia Orbium [online shader](https://www.shadertoy.com/view/4flcD7)
- Lenia Quadrium [online shader](https://www.shadertoy.com/view/XcscD7)

<div style="text-align: center; margin: 20px 0;">
  <figure style="display: inline-block; margin-right: 10px;">
    <img src="gifs/orbium.gif" style="width: 280px; height: 280px;" alt="Lenia Orbium">
  </figure>
  <figure style="display: inline-block;">
    <img src="gifs/quadrium.gif" style="width: 280px; height: 280px;" alt="Lenia Quadrium">
  </figure>
</div>
