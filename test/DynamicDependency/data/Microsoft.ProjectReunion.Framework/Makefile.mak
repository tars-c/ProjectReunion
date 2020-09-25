# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.

#!include <ProjectReunion.Tools.MakeMsix.mak>

!IFDEF VERBOSE
!MESSAGE SolutionDir       =$(SolutionDir)
!MESSAGE ProjectDir        =$(ProjectDir)
!MESSAGE OutDir            =$(OutDir)
!MESSAGE TargetName        =$(TargetName)
!ENDIF

TARGET_BASENAME=Microsoft.ProjectReunion.Framework

TargetDir=$(OutDir)$(TargetName)
WorkDir=$(TargetDir)\msix
OutMsix=$(TargetDir)\$(TargetName).msix

!IFDEF VERBOSE
!MESSAGE Workdir           =$(WorkDir)
!MESSAGE OutMsix           =$(OutMsix)
!ENDIF

all: build

build: $(OutMsix)

$(OutMsix): $(WorkDir)\appxmanifest.xml
    if not exist $(WorkDir) md $(WorkDir)
    copy /Y $(ProjectDir)appxmanifest.xml $(WorkDir)\appxmanifest.xml
    copy /Y $(ProjectDir)logo.png $(WorkDir)\logo.png
    makeappx.exe pack /v /o /h SHA256 /d $(WorkDir) /p $(OutMsix)
    signtool.exe sign /a /v /fd SHA256 /f $(SolutionDir)build\MSTest.pfx $(OutMsix)

clean:
    if exist $(WorkDir) rd $(WorkDir) /s /q
    if exist $(OutMsix) del $(OutMsix)

$(OutMsix): $(ProjectDir)appxmanifest.xml

rebuild: clean build