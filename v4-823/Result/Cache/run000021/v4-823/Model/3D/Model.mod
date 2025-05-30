'# MWS Version: Version 2024.4 - Apr 30 2024 - ACIS 33.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0.7*frequency_centre fmax = 1.3*frequency_centre


'@ use template: Antenna - Planar_23

'[VERSION]2014.6|23.0.0|20141128[/VERSION]
'set the units
With Units
     .Geometry "mm"
     .Frequency "ghz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "NanoH"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "PikoF"
End With
'----------------------------------------------------------------------------
Plot.DrawBox True
With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mue "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With
' optimize mesh settings for planar structures
With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With
With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With
With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With
With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With
' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)
MeshAdaption3D.SetAdaptionStrategy "Energy"
' switch on FD-TET setting for accurate farfields
FDSolver.ExtrudeOpenBC "True"
PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"
'----------------------------------------------------------------------------
With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With
With Mesh
     .MeshType "PBA"
End With
'set the solver type
ChangeSolverType("HF Time Domain")
'----------------------------------------------------------------------------
'preserve project units
With Units 
     .Geometry "mm"
     .Frequency "ghz"
     .Time "ns" 
     .TemperatureUnit "Kelvin" 
     .Voltage "V" 
     .Current "A" 
     .Resistance "Ohm" 
     .Conductance "Siemens" 
     .Capacitance "PikoF" 
     .Inductance "NanoH" 
End With

'@ set workplane properties

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With WCS
     .SetWorkplaneSize "120" 
     .SetWorkplaneRaster "2" 
     .SetWorkplaneSnap "TRUE" 
     .SetWorkplaneSnapRaster "0.1" 
     .SetWorkplaneAutoadjust "TRUE" 
End With

'@ new component: component1

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Component.New "component1"

'@ define brick: component1:solid1

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-groundplane_width/2", "groundplane_width/2" 
     .Yrange "-groundplane_length/2", "groundplane_length/2 + groundplane_feed_extension" 
     .Zrange "-substrate_height", "0" 
     .Create
End With

'@ define material: substrate_material

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Material 
     .Reset 
     .Name "substrate_material"
     .FrqType "all" 
     .Type "Normal" 
     .Epsilon "relative_permittivity" 
     .Mue "1" 
     .Kappa "0" 
     .TanD "0.0" 
     .TanDFreq "0.0" 
     .TanDGiven "False" 
     .TanDModel "ConstTanD" 
     .KappaM "0" 
     .TanDM "0.0" 
     .TanDMFreq "0.0" 
     .TanDMGiven "False" 
     .TanDMModel "ConstTanD" 
     .DispModelEps "None" 
     .DispModelMue "None" 
     .DispersiveFittingSchemeEps "General 1st" 
     .DispersiveFittingSchemeMue "General 1st" 
     .UseGeneralDispersionEps "False" 
     .UseGeneralDispersionMue "False" 
     .Rho "0" 
     .ThermalType "Normal" 
     .ThermalConductivity "0" 
     .HeatCapacity "0" 
     .MetabolicRate "0" 
     .BloodFlow "0" 
     .Colour "0", "1", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material colour: substrate_material

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Material 
     .Name "substrate_material" 
     .Colour "1", "0.501961", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ change material: component1:solid1 to: substrate_material

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Solid.ChangeMaterial "component1:solid1", "substrate_material"

'@ pick face

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Pick.PickFaceFromId "component1:solid1", "2"

'@ define extrude: component1:ground

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Extrude 
     .Reset 
     .Name "ground" 
     .Component "component1" 
     .Material "PEC" 
     .Mode "Picks" 
     .Height "metal_thickness" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ define brick: component1:feed_line

'[VERSION]2010.7|20.0.0|20101029[/VERSION]
With Brick
     .Reset 
     .Name "feed_line" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-0.5*feed_line_width", "0.5*feed_line_width" 
     .Yrange "groundplane_length/2 + groundplane_feed_extension-feed_line_length", "groundplane_length/2 + groundplane_feed_extension" 
     .Zrange "0", "metal_thickness" 
     .Create
End With

'@ define brick: component1:matching_line

'[VERSION]2010.7|20.0.0|20101029[/VERSION]
With Brick
     .Reset 
     .Name "matching_line" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-0.5*matching_line_width", "0.5*matching_line_width" 
     .Yrange "groundplane_length/2 + groundplane_feed_extension-feed_line_length-matching_line_length", "groundplane_length/2 + groundplane_feed_extension-feed_line_length" 
     .Zrange "0", "metal_thickness" 
     .Create
End With

'@ define brick: component1:patch

'[VERSION]2010.7|20.0.0|20101029[/VERSION]
With Brick
     .Reset 
     .Name "patch" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-0.5*patch_width", "0.5*patch_width" 
     .Yrange "groundplane_length/2 + groundplane_feed_extension-feed_line_length-matching_line_length-patch_length", "groundplane_length/2 + groundplane_feed_extension-feed_line_length-matching_line_length" 
     .Zrange "0", "metal_thickness" 
     .Create
End With

'@ define material colour: Vacuum

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Material 
     .Name "Vacuum" 
     .Colour "0.5", "0.8", "1" 
     .Wireframe "True" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "38" 
     .ChangeColour 
End With

'@ define background

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Background 
     .Reset 
     .Type "Normal" 
     .Epsilon "1.0" 
     .Mue "1.0" 
     .ThermalType "Normal" 
     .ThermalConductivity "0.0" 
     .HeatCapacity "0.0" 
     .Rho "0.0" 
     .XminSpace "0.0" 
     .XmaxSpace "0.0" 
     .YminSpace "0.0" 
     .YmaxSpace "0.0" 
     .ZminSpace "0.0" 
     .ZmaxSpace "0.0" 
     .ApplyInAllDirections "False" 
End With

'@ define port: 1

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .NumberOfModes "1" 
     .AdjustPolarization False 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Free" 
     .Orientation "ymax" 
     .PortOnBound "False" 
     .ClipPickedPortToBound "False" 
     .Xrange "-10*substrate_height-feed_line_width/2", "10*substrate_height+feed_line_width/2" 
     .Yrange "patch_length/2+matching_line_length+feed_line_length", "patch_length/2+matching_line_length+feed_line_length" 
     .Zrange "-1*substrate_height", "9*substrate_height" 
     .XrangeAdd "0.0", "0.0" 
     .YrangeAdd "0.0", "0.0" 
     .ZrangeAdd "0.0", "0.0" 
     .SingleEnded "False" 
     .Create 
End With

'@ define boundaries

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Boundary
     .Xmin "expanded open" 
    .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "magnetic" 
     .Ysymmetry "none" 
     .Zsymmetry "none" 
     .XminThermal "isothermal" 
     .XmaxThermal "isothermal" 
     .YminThermal "isothermal" 
     .YmaxThermal "isothermal" 
     .ZminThermal "isothermal" 
     .ZmaxThermal "isothermal" 
     .XsymmetryThermal "none" 
     .YsymmetryThermal "none" 
     .ZsymmetryThermal "none" 
     .ApplyInAllDirections "True" 
     .XminTemperature "" 
     .XminTemperatureType "None" 
     .XmaxTemperature "" 
     .XmaxTemperatureType "None" 
     .YminTemperature "" 
     .YminTemperatureType "None" 
     .YmaxTemperature "" 
     .YmaxTemperatureType "None" 
     .ZminTemperature "" 
     .ZminTemperatureType "None" 
     .ZmaxTemperature "" 
     .ZmaxTemperatureType "None" 
End With

'@ define frequency range

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Solver.FrequencyRange "0", "1.1*frequency_centre"

'@ define farfield monitor: farfield (f=frequency_centre)

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=frequency_centre)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
	    .Frequency "frequency_centre" 
     .Create 
End With

'@ define farfield monitor: farfield (f=0.9frequency_centre)

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=0.9frequency_centre)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
	    .Frequency "0.9*frequency_centre" 
     .Create 
End With

'@ define farfield monitor: farfield (f=1.1frequency_centre)

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=1.1frequency_centre)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
	    .Frequency "1.1*frequency_centre" 
     .Create 
End With

'@ clear picks

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Pick.ClearAllPicks

'@ define frequency range

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Solver.FrequencyRange "0.7*frequency_centre", "1.3*frequency_centre"

'@ switch working plane

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Plot.DrawWorkplane "false"

'@ define automesh for: component1:feed_line

'[VERSION]2010.7|20.0.0|20101029[/VERSION]
Mesh.MeshType "PBA"
Solid.SetSolidLocalMeshProperties "component1:feed_line", "PBA", "True", "0", "True", "True", "feed_line_width/4", "0", "0", "0", "0", "0", "False", "1.0", "False", "1.0", "False", "True", "True", "True"

'@ define automesh for: component1:matching_line

'[VERSION]2010.7|20.0.0|20101029[/VERSION]
Mesh.MeshType "PBA"
Solid.SetSolidLocalMeshProperties "component1:matching_line", "PBA", "True", "0", "True", "True", "matching_line_width/4", "0", "0", "0", "0", "0", "False", "1.0", "False", "1.0", "False", "True", "True", "True"

'@ define automesh parameters

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Mesh 
     .AutomeshStraightLines "True" 
     .AutomeshEllipticalLines "True" 
     .AutomeshRefineAtPecLines "True", "7" 
     .AutomeshRefinePecAlongAxesOnly "False" 
     .AutomeshAtEllipseBounds "True", "10" 
     .AutomeshAtWireEndPoints "True" 
     .AutomeshAtProbePoints "True" 
     .SetAutomeshRefineDielectricsType "Generalized" 
     .MergeThinPECLayerFixpoints "True" 
     .EquilibrateMesh "False" 
     .EquilibrateMeshRatio "1.19" 
     .UseCellAspectRatio "False" 
     .CellAspectRatio "50.0" 
     .UsePecEdgeModel "True" 
     .MeshType "PBA" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
     .PointAccEnhancement "0" 
     .SurfaceOptimization "True" 
     .SurfaceSmoothing "3" 
     .MinimumCurvatureRefinement "100" 
     .CurvatureRefinementFactor "0.05" 
     .AnisotropicCurvatureRefinement "False" 
     .SmallFeatureSize "0.0" 
     .SurfaceTolerance "0.0" 
     .SurfaceToleranceType "Relative" 
     .NormalTolerance "22.5" 
     .AnisotropicCurvatureRefinementFSM "False" 
     .SurfaceMeshEnrichment "0" 
     .DensityTransitionsFSM "0.5" 
     .VolumeOptimization "True" 
     .VolumeSmoothing "True" 
     .VolumeMeshMethod "Delaunay" 
     .SurfaceMeshMethod "General" 
     .SurfaceMeshGeometryAccuracy "1.0e-6" 
     .DelaunayOptimizationLevel "2" 
     .DelaunayPropagationFactor "1.050000" 
     .DensityTransitions "0.5" 
     .MeshAllRegions "False" 
     .ConvertGeometryDataAfterMeshing "True" 
     .AutomeshFixpointsForBackground "True" 
     .PBAType "Fast PBA" 
     .AutomaticPBAType "True" 
     .FPBAAvoidNonRegUnite "True" 
     .DetectSmallSolidPEC "False" 
     .ConsiderSpaceForLowerMeshLimit "False" 
     .RatioLimitGovernsLocalRefinement "False" 
     .GapDetection "False" 
     .FPBAGapTolerance "1e-3" 
     .MaxParallelThreads "8"
     .SetParallelMode "Maximum"
End With 
With Solver 
     .UseSplitComponents "True" 
     .PBAFillLimit "99" 
     .EnableSubgridding "False" 
     .AlwaysExcludePec "False" 
End With

'@ rename block: component1:solid1 to: component1:substrate

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Solid.Rename "component1:solid1", "substrate"

'@ define automesh for: component1:substrate

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Solid.SetSolidMeshProperties "component1:substrate", "PBA", "True", "0", "True", "True", "0", "0", "substrate_height/3", "0", "0", "substrate_height/2", "False", "1.0", "False", "1.0", "False", "True", "True"

'@ set mesh properties

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "20" 
     .LinesPerWavelength "20" 
     .MinimumStepNumber "5" 
     .Automesh "True" 
     .MeshType "PBA" 
     .SetCreator "High Frequency" 
End With

'@ define solver parameters

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseDistributedComputing "False" 
     .DistributeMatrixCalculation "False" 
     .MPIParallelization "False" 
     .SuperimposePLWExcitation "False" 
End With

'@ farfield plot options

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With FarfieldPlot 
     .Plottype "Polar" 
     .Vary "phi" 
     .Theta "90" 
     .Phi "90" 
     .Step "1" 
     .Step2 "1" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "2.4" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "True" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .DBUnit "0" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "False" 
     .AlignToMainLobe "False" 
     .Phistart "1.000000e+000", "0.000000e+000", "0.000000e+000" 
     .Thetastart "0.000000e+000", "0.000000e+000", "1.000000e+000" 
     .PolarizationVector "0", "1", "0" 
     .SetCoordinateSystemType "spherical" 
     .Origin "bbox" 
     .Userorigin "0.000000e+000", "0.000000e+000", "0.000000e+000" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+000" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "30" 
     .SetPhaseCenterComponent "Theta" 
     .SetPhaseCenterPlane "both" 
End With

'@ define pml specials

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Boundary
     .SetPMLType "ConvPML" 
     .Layer "4" 
     .Reflection "0.0001" 
     .Progression "parabolic" 
     .MinimumLinesDistance "5" 
     .MinimumDistancePerWavelength "4" 
     .ActivePMLFactor "1.0" 
     .FrequencyForMinimumDistance "2.4" 
     .MinimumDistanceAtCenterFrequency "True" 
     .SetConvPMLKMax "5.0" 
     .SetConvPMLExponentM "3" 
End With

'@ define special solver parameters

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With Solver 
     .TimeBetweenUpdates "1200" 
     .NumberOfPulseWidths "20" 
     .EnergyBalanceLimit "0.03" 
     .UseArfilter "False" 
     .ArMaxEnergyDeviation "0.1" 
     .ArPulseSkip "1" 
     .WaveguideBroadband "False" 
     .SetBBPSamples "5" 
     .SetSamplesFullDeembedding "20" 
     .MatrixDump "False" 
     .TimestepReduction "0.45" 
     .NumberOfSubcycles "4" 
     .SubcycleFillLimit "70" 
     .SetSubcycleState "Automatic" 
     .SetSubgridCycleState "Automatic" 
     .SimplifiedPBAMethod "False" 
     .UseParallelization "True" 
     .MaximumNumberOfThreads "16" 
     .TimeStepStabilityFactor "1.0" 
     .UseOpenBoundaryForHigherModes "True" 
     .SetModeFreqFactor "0.5" 
     .SurfaceImpedanceOrder "10" 
     .SetPortShielding "True" 
     .FrequencySamples "1001" 
     .ConsiderTwoPortReciprocity "True" 
     .UseTSTAtPort "True" 
     .SParaAdjustment "True" 
     .RestartAfterInstabilityAbort "True" 
     .HardwareAcceleration "False" 
     .AdaptivePortMeshing "True" 
     .AccuracyAdaptivePortMeshing "1" 
     .PassesAdaptivePortMeshing "4" 
End With

'@ define frequency domain solver parameters

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Mesh.SetCreator "High Frequency" 
With FDSolver
     .Reset 
     .Method "Tetrahedral Mesh" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .NetworkComputingJobCount "3" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .LimitCPUs "False" 
     .MaxCPUs "8" 
     .CalculateExcitationsInParallel "True" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .HexMORSettings "", "1001" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "False" 
     .MixedOrder "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.20" 
     .UseCFIEForCPECIntEq "true" 
     .UseFastRCSSweepIntEq "true" 
     .SetRCSSweepProperties "0.0", "0.0", "0","0.0", "0.0", "0", "0" 
     .SweepErrorThreshold "True", "0.01" 
     .SweepErrorChecks "2" 
     .SweepMinimumSamples "3" 
     .SweepConsiderAll "True" 
     .SweepConsiderReset 
     .InterpolationSamples "1001" 
     .SweepWeightEvanescent "1.0" 
     .AddSampleInterval "frequency_centre", "", "1", "Automatic", "True" 
     .AddSampleInterval "0.7*frequency_centre", "1.3*frequency_centre", "", "Automatic", "False" 
End With
With IESolver
     .Reset 
     .UseFastFrequencySweep "False" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
End With
With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
End With

'@ set 3d mesh adaptation properties

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "16" 
    .MeshIncrement "5.0" 
    .MaxDeltaS "0.01" 
    .NumberOfDeltaSChecks "2" 
    .PropagationConstantAccuracy "0.005" 
    .NumberOfPropConstChecks   "2" 
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor            "30" 
    .SetMinimumMeshCellGrowth  "5" 
    .ErrorEstimatorType        "Automatic" 
    .RefinementType            "Automatic" 
    .ImproveBadElementQuality  "True" 
    .SubsequentChecksOnlyOnce  "False" 
    .WavelengthBasedRefinement "True" 
    .EnableLinearGrowthLimitation "True" 
    .SetLinearGrowthLimitation "30" 
End With

'@ define solver parameters

'[VERSION]2009.6|18.0.3|20090230[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseDistributedComputing "False" 
     .DistributeMatrixCalculation "False" 
     .MPIParallelization "False" 
     .SuperimposePLWExcitation "False" 
End With

'@ set units in materials

'[VERSION]2010.7|20.0.0|20101029[/VERSION]
Material.SetUnitInMaterial "PEC_Clear", "GHz", "mm" 
Material.SetUnitInMaterial "substrate_material", "GHz", "mm"

'@ define solver parameters

'[VERSION]2010.7|20.0.0|20101029[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
End With

'@ change solver and mesh type

'[VERSION]2014.6|23.0.0|20141128[/VERSION]
ChangeSolverAndMeshType "HF Time Domain"

'@ define time domain solver parameters

'[VERSION]2014.6|23.0.0|20141128[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set mesh properties (Hexahedral)

'[VERSION]2014.6|23.0.0|20141128[/VERSION]
With Mesh 
     .MeshType "PBA" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "20" 
     .Set "StepsPerWaveFar", "20" 
     .Set "WavelengthRefinementSameAsNear", "1" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "20" 
     .Set "StepsPerBoxFar", "5" 
     .Set "MaxStepNear", "0" 
     .Set "MaxStepFar", "0" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     .Set "UseMaxStepAbsolute", "0" 
     .Set "GeometryRefinementSameAsNear", "0" 
     'MIN CELL 
     .Set "UseRatioLimitGeometry", "0" 
     .Set "RatioLimitGeometry", "5" 
     .Set "MinStepGeometryX", "0" 
     .Set "MinStepGeometryY", "0" 
     .Set "MinStepGeometryZ", "0" 
     .Set "UseSameMinStepGeometryXYZ", "1" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "FaceRefinementOn", "0" 
     .Set "FaceRefinementPolicy", "2" 
     .Set "FaceRefinementRatio", "2" 
     .Set "FaceRefinementStep", "0" 
     .Set "FaceRefinementNSteps", "2" 
     .Set "EllipseRefinementOn", "0" 
     .Set "EllipseRefinementPolicy", "2" 
     .Set "EllipseRefinementRatio", "2" 
     .Set "EllipseRefinementStep", "0" 
     .Set "EllipseRefinementNSteps", "2" 
     .Set "FaceRefinementBufferLines", "3" 
     .Set "EdgeRefinementOn", "1" 
     .Set "EdgeRefinementPolicy", "1" 
     .Set "EdgeRefinementRatio", "2" 
     .Set "EdgeRefinementStep", "0" 
     .Set "EdgeRefinementBufferLines", "3" 
     .Set "RefineEdgeMaterialGlobal", "0" 
     .Set "RefineAxialEdgeGlobal", "0" 
     .Set "BufferLinesNear", "3" 
     .Set "UseDielectrics", "1" 
     .Set "EquilibrateOn", "0" 
     .Set "Equilibrate", "1.5" 
     .Set "IgnoreThinPanelMaterial", "0" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "SnapToAxialEdges", "1"
     .Set "SnapToPlanes", "1"
     .Set "SnapToSpheres", "1"
     .Set "SnapToEllipses", "1"
     .Set "SnapToCylinders", "1"
     .Set "SnapToCylinderCenters", "1"
     .Set "SnapToEllipseCenters", "1"
End With 
With Discretizer 
     .MeshType "PBA" 
     .PBAType "Fast PBA" 
     .AutomaticPBAType "True" 
     .FPBAAccuracyEnhancement "enable"
     .ConnectivityCheck "False"
     .ConvertGeometryDataAfterMeshing "True" 
     .UsePecEdgeModel "True" 
     .GapDetection "False" 
     .FPBAGapTolerance "1e-3" 
     .SetMaxParallelMesherThreads "Hex", "8"
     .SetParallelMesherMode "Hex", "Maximum"
     .PointAccEnhancement "0" 
     .UseSplitComponents "True" 
     .EnableSubgridding "False" 
     .PBAFillLimit "99" 
     .AlwaysExcludePec "False" 
End With

'@ ___________Magus Anchor Point Creation___________

'[VERSION]2014.6|23.0.0|20090230[/VERSION]
            
        '[VERSION]2017.5|26.0.1|20170804[/VERSION]
        '@ execute macro: CreateMagusBoundaryAnchorPoints
        '[VERSION]2017.5|26.0.1|20170804[/VERSION]
        ' Extract and store the original boundary conditions
        Dim XminBoundaryType As String
        Dim XmaxBoundaryType As String
        Dim YminBoundaryType As String
        Dim YmaxBoundaryType As String
        Dim ZminBoundaryType As String
        Dim ZmaxBoundaryType As String
        XminBoundaryType = Boundary.GetXmin
        XmaxBoundaryType = Boundary.GetXmax
        YminBoundaryType = Boundary.GetYmin
        YmaxBoundaryType = Boundary.GetYmax
        ZminBoundaryType = Boundary.GetZmin
        ZmaxBoundaryType = Boundary.GetZmax
        ' Set the boundary to open in all directions
        Dim TightBoundary As String
        TightBoundary = "open"
        Boundary.Xmin(TightBoundary)
        Boundary.Xmax(TightBoundary)
        Boundary.Ymin(TightBoundary)
        Boundary.Ymax(TightBoundary)
        Boundary.Zmin(TightBoundary)
        Boundary.Zmax(TightBoundary)
        ' Setup WCS
        WCS.AlignWCSWithGlobalCoordinates
        ' Variables used to extract the "tight" bounding box
        Dim xmin As Double
        Dim xmax As Double
        Dim ymin As Double
        Dim ymax As Double
        Dim zmin As Double
        Dim zmax As Double
        Boundary.GetCalculationBox(xmin, xmax, ymin, ymax, zmin, zmax)
        ' Set the the original boundary conditions back to what they were
        Boundary.Xmin(XminBoundaryType)
        Boundary.Xmax(XmaxBoundaryType)
        Boundary.Ymin(YminBoundaryType)
        Boundary.Ymax(YmaxBoundaryType)
        Boundary.Zmin(ZminBoundaryType)
        Boundary.Zmax(ZmaxBoundaryType)
        ' Anchor Points
        Dim AnchorPointFolderName As String
        AnchorPointFolderName = "Boundary"
        ' Move the local WCS to the boundaries, orientate so that the normal points outward
        Dim du As Double
        Dim dv As Double
        Dim dw As Double
        ' Zmax
        du = 0.5*( xmin + xmax)
        dv = 0.5*( ymin + ymax)
        dw = zmax
        WCS.MoveWCS "local", du, dv, dw
        ' Set Zmax Anchor Point
        AnchorPoint.Store AnchorPointFolderName + ":" + "Zmax"
        ' Store WCS of current Anchor Point
        WCS.Store "Zmax"
        'Realign WCS with global
        WCS.AlignWCSWithGlobalCoordinates
        ' Zmin
        du = 0.5*( xmin + xmax)
        dv = 0.5*( ymin + ymax)
        dw = zmin
        WCS.MoveWCS "local", du, dv, dw
        WCS.SetNormal "0", "0", "-1"
        ' Set Zmin Anchor Point
        AnchorPoint.Store AnchorPointFolderName + ":" + "Zmin"
        ' Store WCS of current Anchor Point
        WCS.Store "Zmin"
        'Realign WCS with global
        WCS.AlignWCSWithGlobalCoordinates
        ' Xmax
        du = xmax
        dv = 0.5*( ymin + ymax)
        dw = 0.5*( zmin + zmax)
        WCS.MoveWCS "local", du, dv, dw
        WCS.SetNormal "1", "0", "0"
        ' Set Zmin Anchor Point
        AnchorPoint.Store AnchorPointFolderName + ":" + "Xmax"
        ' Store WCS of current Anchor Point
        WCS.Store "Xmax"
        'Realign WCS with global
        WCS.AlignWCSWithGlobalCoordinates
        ' Xmin
        du = xmin
        dv = 0.5*( ymin + ymax)
        dw = 0.5*( zmin + zmax)
        WCS.MoveWCS "local", du, dv, dw
        WCS.SetNormal "-1", "0", "0"
        ' Set Zmin Anchor Point
        AnchorPoint.Store AnchorPointFolderName + ":" + "Xmin"
        ' Store WCS of current Anchor Point
        WCS.Store "Xmin"
        'Realign WCS with global
        WCS.AlignWCSWithGlobalCoordinates
        ' Ymax
        du = 0.5*( xmin + xmax)
        dv = ymax
        dw = 0.5*( zmin + zmax)
        WCS.MoveWCS "local", du, dv, dw
        WCS.SetNormal "0", "1", "0"
        ' Set Zmin Anchor Point
        AnchorPoint.Store AnchorPointFolderName + ":" + "Ymax"
        ' Store WCS of current Anchor Point
        WCS.Store "Ymax"
        'Realign WCS with global
        WCS.AlignWCSWithGlobalCoordinates
        ' Ymin
        du = 0.5*( xmin + xmax)
        dv = ymin
        dw = 0.5*( zmin + zmax)
        WCS.MoveWCS "local", du, dv, dw
        WCS.SetNormal "0", "-1", "0"
        ' Set Zmin Anchor Point
        AnchorPoint.Store AnchorPointFolderName + ":" + "Ymin"
        ' Store WCS of current Anchor Point
        WCS.Store "Ymin"
        'Realign WCS with global
        WCS.AlignWCSWithGlobalCoordinates
        
      '@ ___________End: Magus Anchor Point Creation___________

'@ create group: meshgroup1

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
Group.Add "meshgroup1", "mesh"

'@ set local mesh properties for: meshgroup1

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
With MeshSettings
     With .ItemMeshSettings ("group$meshgroup1")
          .SetMeshType "Hex"
          .Set "EdgeRefinement", "1.0"
          .Set "Extend", "0", "0", "substrate_height/2"
          .Set "Fixpoints", 1
          .Set "MeshType", "Default"
          .Set "NumSteps", 0, 0, 0
          .Set "Priority", "0"
          .Set "RefinementPolicy", "ABS_VALUE"
          .Set "SnappingIntervals", 0, 0, 0
          .Set "SnappingPriority", 0
          .Set "SnapTo", 1, 1, 1
          .Set "Step", "0", "0", "substrate_height/3"
          .Set "StepRatio", 0, 0, 0
          .Set "StepRefinementCollectPolicy", "REFINE_ALL"
          .Set "StepRefinementExtentPolicy", "EXTENT_ABS_VALUE"
          .Set "UseDielectrics", 1
          .Set "UseEdgeRefinement", 0
          .Set "UseForRefinement", 1
          .Set "UseForSnapping", 1
          .Set "UseSameExtendXYZ", 1
          .Set "UseSameStepWidthXYZ", 1
          .Set "UseSnappingPriority", 0
          .Set "UseStepAndExtend", 1
          .Set "UseVolumeRefinement", 0
          .Set "VolumeRefinement", "1.0"
          .SetMeshType "HexTLM"
          .Set "EdgeRefinement", "1.0"
          .Set "Extend", "0", "0", "substrate_height/2"
          .Set "NumSteps", 0, 0, 0
          .Set "RefinementPolicy", "ABS_VALUE"
          .Set "SnappingIntervals", 0, 0, 0
          .Set "SnappingPriority", 0
          .Set "SnapTo", 1, 1, 1
          .Set "Step", "0", "0", "substrate_height/3"
          .Set "StepRatio", 0, 0, 0
          .Set "StepRefinementCollectPolicy", "REFINE_ALL"
          .Set "StepRefinementExtentPolicy", "EXTENT_ABS_VALUE"
          .Set "UnlumpWithin", 0
          .Set "UseDielectrics", 1
          .Set "UseEdgeRefinement", 0
          .Set "UseForRefinement", 1
          .Set "UseForSnapping", 1
          .Set "UseSameExtendXYZ", 1
          .Set "UseSameStepWidthXYZ", 1
          .Set "UseSnappingPriority", 0
          .Set "UseStepAndExtend", 1
          .Set "UseVolumeRefinement", 0
          .Set "VolumeRefinement", "1.0"
     End With
End With

'@ create group: meshgroup2

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
Group.Add "meshgroup2", "mesh"

'@ set local mesh properties for: meshgroup2

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
With MeshSettings
     With .ItemMeshSettings ("group$meshgroup2")
          .SetMeshType "Hex"
          .Set "EdgeRefinement", "1.0"
          .Set "Extend", "0", "0", "0"
          .Set "Fixpoints", 1
          .Set "MeshType", "Default"
          .Set "NumSteps", 0, 0, 0
          .Set "Priority", "0"
          .Set "RefinementPolicy", "ABS_VALUE"
          .Set "SnappingIntervals", 0, 0, 0
          .Set "SnappingPriority", 0
          .Set "SnapTo", 1, 1, 1
          .Set "Step", "feed_line_width/4", "0", "0"
          .Set "StepRatio", 0, 0, 0
          .Set "StepRefinementCollectPolicy", "REFINE_ALL"
          .Set "StepRefinementExtentPolicy", "EXTENT_ABS_VALUE"
          .Set "UseDielectrics", 1
          .Set "UseEdgeRefinement", 0
          .Set "UseForRefinement", 1
          .Set "UseForSnapping", 1
          .Set "UseSameExtendXYZ", 1
          .Set "UseSameStepWidthXYZ", 1
          .Set "UseSnappingPriority", 0
          .Set "UseStepAndExtend", 1
          .Set "UseVolumeRefinement", 0
          .Set "VolumeRefinement", "1.0"
          .SetMeshType "HexTLM"
          .Set "EdgeRefinement", "1.0"
          .Set "Extend", "0", "0", "0"
          .Set "NumSteps", 0, 0, 0
          .Set "RefinementPolicy", "ABS_VALUE"
          .Set "SnappingIntervals", 0, 0, 0
          .Set "SnappingPriority", 0
          .Set "SnapTo", 1, 1, 1
          .Set "Step", "feed_line_width/4", "0", "0"
          .Set "StepRatio", 0, 0, 0
          .Set "StepRefinementCollectPolicy", "REFINE_ALL"
          .Set "StepRefinementExtentPolicy", "EXTENT_ABS_VALUE"
          .Set "UnlumpWithin", 0
          .Set "UseDielectrics", 1
          .Set "UseEdgeRefinement", 0
          .Set "UseForRefinement", 1
          .Set "UseForSnapping", 1
          .Set "UseSameExtendXYZ", 1
          .Set "UseSameStepWidthXYZ", 1
          .Set "UseSnappingPriority", 0
          .Set "UseStepAndExtend", 1
          .Set "UseVolumeRefinement", 0
          .Set "VolumeRefinement", "1.0"
     End With
End With

'@ create group: meshgroup3

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
Group.Add "meshgroup3", "mesh"

'@ set local mesh properties for: meshgroup3

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
With MeshSettings
     With .ItemMeshSettings ("group$meshgroup3")
          .SetMeshType "Hex"
          .Set "EdgeRefinement", "1.0"
          .Set "Extend", "0", "0", "0"
          .Set "Fixpoints", 1
          .Set "MeshType", "Default"
          .Set "NumSteps", 0, 0, 0
          .Set "Priority", "0"
          .Set "RefinementPolicy", "ABS_VALUE"
          .Set "SnappingIntervals", 0, 0, 0
          .Set "SnappingPriority", 0
          .Set "SnapTo", 1, 1, 1
          .Set "Step", "matching_line_width/4", "0", "0"
          .Set "StepRatio", 0, 0, 0
          .Set "StepRefinementCollectPolicy", "REFINE_ALL"
          .Set "StepRefinementExtentPolicy", "EXTENT_ABS_VALUE"
          .Set "UseDielectrics", 1
          .Set "UseEdgeRefinement", 0
          .Set "UseForRefinement", 1
          .Set "UseForSnapping", 1
          .Set "UseSameExtendXYZ", 1
          .Set "UseSameStepWidthXYZ", 1
          .Set "UseSnappingPriority", 0
          .Set "UseStepAndExtend", 1
          .Set "UseVolumeRefinement", 0
          .Set "VolumeRefinement", "1.0"
          .SetMeshType "HexTLM"
          .Set "EdgeRefinement", "1.0"
          .Set "Extend", "0", "0", "0"
          .Set "NumSteps", 0, 0, 0
          .Set "RefinementPolicy", "ABS_VALUE"
          .Set "SnappingIntervals", 0, 0, 0
          .Set "SnappingPriority", 0
          .Set "SnapTo", 1, 1, 1
          .Set "Step", "matching_line_width/4", "0", "0"
          .Set "StepRatio", 0, 0, 0
          .Set "StepRefinementCollectPolicy", "REFINE_ALL"
          .Set "StepRefinementExtentPolicy", "EXTENT_ABS_VALUE"
          .Set "UnlumpWithin", 0
          .Set "UseDielectrics", 1
          .Set "UseEdgeRefinement", 0
          .Set "UseForRefinement", 1
          .Set "UseForSnapping", 1
          .Set "UseSameExtendXYZ", 1
          .Set "UseSameStepWidthXYZ", 1
          .Set "UseSnappingPriority", 0
          .Set "UseStepAndExtend", 1
          .Set "UseVolumeRefinement", 0
          .Set "VolumeRefinement", "1.0"
     End With
End With

'@ add items to group: "meshgroup1"

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
Group.AddItem "solid$component1:substrate", "meshgroup1"

'@ add items to group: "meshgroup2"

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
Group.AddItem "solid$component1:feed_line", "meshgroup2"

'@ add items to group: "meshgroup3"

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
Group.AddItem "solid$component1:matching_line", "meshgroup3"

'@ set local mesh properties (for backward compatibility)

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
With MeshSettings
     With .ItemMeshSettings ("group$meshgroup1")
          .SetMeshType "Hex"
          .Set "UseSameStepWidthXYZ", 0
          .SetMeshType "Hex"
          .Set "UseSameExtendXYZ", 0
          .SetMeshType "HexTLM"
          .Set "UseSameStepWidthXYZ", 0
          .SetMeshType "HexTLM"
          .Set "UseSameExtendXYZ", 0
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("group$meshgroup2")
          .SetMeshType "Hex"
          .Set "UseSameStepWidthXYZ", 0
          .SetMeshType "HexTLM"
          .Set "UseSameStepWidthXYZ", 0
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("group$meshgroup3")
          .SetMeshType "Hex"
          .Set "UseSameStepWidthXYZ", 0
          .SetMeshType "HexTLM"
          .Set "UseSameStepWidthXYZ", 0
     End With
End With

'@ set mesh properties (for backward compatibility)

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 0%
     .SetMeshType "Srf"
     .Set "Version", 0%
End With

With MeshSettings 
    .SetMeshType "Hex"
    .Set "PlaneMergeVersion", 0
End With

'@ change solver type

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
ChangeSolverType "HF Frequency Domain"

'@ set mesh properties (Tetrahedral)

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
With Mesh 
     .MeshType "Tetrahedral" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "4" 
     .Set "StepsPerWaveFar", "4" 
     .Set "PhaseErrorNear", "0.02" 
     .Set "PhaseErrorFar", "0.02" 
     .Set "CellsPerWavelengthPolicy", "cellsperwavelength" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "10" 
     .Set "StepsPerBoxFar", "1" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     'MIN CELL 
     .Set "UseRatioLimit", "0" 
     .Set "RatioLimit", "100" 
     .Set "MinStep", "0" 
     'MESHING METHOD 
     .SetMeshType "Unstr" 
     .Set "Method", "0" 
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "CurvatureOrder", "1" 
     .Set "CurvatureOrderPolicy", "automatic" 
     .Set "CurvRefinementControl", "NormalTolerance" 
     .Set "NormalTolerance", "22.5" 
     .Set "SrfMeshGradation", "1.5" 
     .Set "SrfMeshOptimization", "1" 
End With 
With MeshSettings 
     .SetMeshType "Unstr" 
     .Set "UseMaterials",  "1" 
     .Set "MoveMesh", "0" 
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "UseAnisoCurveRefinement", "1" 
     .Set "UseSameSrfAndVolMeshGradation", "1" 
     .Set "VolMeshGradation", "1.5" 
     .Set "VolMeshOptimization", "1" 
End With 
With MeshSettings 
     .SetMeshType "Unstr" 
     .Set "SmallFeatureSize", "0" 
     .Set "CoincidenceTolerance", "1e-06" 
     .Set "SelfIntersectionCheck", "1" 
     .Set "OptimizeForPlanarStructures", "0" 
End With 
With Mesh 
     .SetParallelMesherMode "Tet", "maximum" 
     .SetMaxParallelMesherThreads "Tet", "1" 
End With

'@ define frequency domain solver parameters

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcStatBField "False" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.20" 
     .UseCFIEForCPECIntEq "True" 
     .UseFastRCSSweepIntEq "true" 
     .UseSensitivityAnalysis "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "frequency_centre", "", "1", "Single", "True" 
     .AddSampleInterval "0.7*frequency_centre", "1.3*frequency_centre", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "False"
     .MaxCPUs "8"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "True" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
End With

'@ change solver type

'[VERSION]2018.6|27.0.2|20180615[/VERSION]
ChangeSolverType "HF Time Domain"

'@ Exported from Antenna Magus: Rectangular edge-fed patch antenna - Friday, December 13, 2024

'[VERSION]2018.6|27.0.2|20090230[/VERSION]

'@ change solver type

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
ChangeSolverType "HF Frequency Domain"

'@ define frequency domain solver parameters

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .SetKeepSolutionCoefficients "All" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.20" 
     .UseCFIEForCPECIntEq "True" 
     .UseEnhancedCFIE2 "True" 
     .UseFastRCSSweepIntEq "true" 
     .UseSensitivityAnalysis "False" 
     .UseEnhancedNFSImprint "True" 
     .UseFastDirectFFCalc "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "frequency_centre", "frequency_centre", "1", "Single", "True" 
     .AddSampleInterval "5.735", "5.815", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "False"
     .MaxCPUs "8"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "True" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
     .DetectThinDielectrics "True" 
End With

'@ farfield plot options

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "2.4" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "True" 
     .ShowStructureProfile "True" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "True" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .InvertAxes "False", "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "theta" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 

     .StoreSettings
End With

'@ store settings for second order

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
FDSolver.BackupOrderSettingsTet "2,2,4,30,True,30,0,4"

'@ change settings for third order

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With MeshAdaption3D
     .SetType "HighFrequencyTet" 
     .RefThetaFactor "30" 
     .EnableLinearGrowthLimitation "True" 
     .SetLinearGrowthLimitation "30" 
End With 
With MeshSettings
     .SetMeshType "Tet" 
     .Set "StepsPerWaveNear", "2" 
     .Set "StepsPerWaveFar", "2" 
End With

'@ define frequency domain solver parameters

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Third" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "True" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .SetKeepSolutionCoefficients "All" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.20" 
     .UseCFIEForCPECIntEq "True" 
     .UseEnhancedCFIE2 "True" 
     .UseFastRCSSweepIntEq "true" 
     .UseSensitivityAnalysis "False" 
     .UseEnhancedNFSImprint "True" 
     .UseFastDirectFFCalc "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "frequency_centre", "frequency_centre", "1", "Single", "True" 
     .AddSampleInterval "5.735", "5.815", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "False"
     .MaxCPUs "8"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "True" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
     .DetectThinDielectrics "True" 
End With

FDSolver.BackupOrderSettingsTet("2,2,4,30,True,30,0,4")

