# ROTOR TOOLBOX
Rotor Toolbox for novel damping mechanism investigations

--------------------------------------------------------------------------
HOW TO INSTALL RotorToolBox

1. Create a folder somewhere in your PC
   ```
   mkdir RotorToolBox
   ```

2. Clone the git repository to the folder you just created
   ```
   git clone https://github.com/alexal00/RotorToolBox.git
   ```
   or download a fresh copy of the source code of RotorToolBox at [git page](https://github.com/alexal00/RotorToolBox)

   Once you have donwloaded the source code follow the 
   next instructions.

3. Startup Matlab and add "path_to_rotortoolbox/RotorToolBox" directory to 
   MATLAB search path. To achieve this, you should do either:

    * Look for the "Environment" then choose "Set Path" and Add Folder and select "path_to_rototoolbox/RotorToolBox" then Save and Close

    or

    * Add the following line to your startup.m file:
      path(path,'path_to_rotortoolbox/RotorToolBox'); [linux platforms]
      path(path,'path_to_rotortoolbox\RotorToolBox'); [Windows platforms]

--------------------------------------------------------------------------
HOW TO STARTUP RotorToolBox

1. Once you have succesfully installed RotorToolBox the next step is to type
   at matlab command window
   >> setRotorToolBoxPath

   After this, the toolbox functions provided by RotorToolBox can be fond at
   MATLAB path. 
2. Then follow the displayed instructions
   >> help RotorToolBox
   
3. Check demos of the RotorToolBox. Follow the next instructions
   a) click the help icon "?" 
   b) look for "Supplemental Software" at the page 
   c) Then click the link "RotorToolBoxBeta Toolbox". Please note that if the link does not appear it means that something went wrong at step 1. Try to setup the RotorToolBox path by typing at the matlab command window >> setRotorToolBoxPath
   d) Finally click the link "WT Toolbox Demos" and the list of demos of the RotorToolBox will appear.

Happy RotorToolBoxing!
