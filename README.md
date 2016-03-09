#VR DATAMOSH

For use with the organic rift/ar setup using the logitech cameras

Shader by Michael Parisi

* Edit shader file: Assets/Standard Assets/Effects/ImageEffects/Shaders/TwirlEffect.shader
* Edit shader controller file: Assets/Standard Assets/Effects/ImageEffects/Scripts/Twirl.cs

* Threshold parameter is controlled by the left joystick's Y value
* Offset parameter is controlled by the right joystick's Y value

*If camera lights are not lighting up after pressing play or if the right and left are switched, you may need to change the camera number: Click on the webcam node and change the number in the settings to the right. Play around till you find what works




##instructions from original project:

#Oculus Rift and two webcams in unity

This repo is a quick test made in Unity. It allow to use two webcams with the Oculus Rift

##Example

![Oculus Rift Webcams](https://pbs.twimg.com/media/B457ojEIAAASKzu.jpg:large)

##How it works

This code creates a WebCamTexture() for each webcams, on two planes, for the left eye and for the right one. 


##Set up

* Connect two identicals webcams

* Press play in the Unity editor

###Extra informations

For a nice result, don't hesitate to take some times to calibrate the webcams on the Oculus.

Sometimes you need to invert (physicaly) the webcams to fit them in the oculus rift. To do that, you just have to enable  *Rotate plane* boolean.
