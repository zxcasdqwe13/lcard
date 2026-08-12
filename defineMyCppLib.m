%% About defineMyCppLib.m
% This file defines the MATLAB interface to the library |MyCppLib|.
%
% Commented sections represent C++ functionality that MATLAB cannot automatically define. To include
% functionality, uncomment a section and provide values for <SHAPE>, <DIRECTION>, etc. For more
% information, see helpview(fullfile(docroot,'matlab','helptargets.map'),'cpp_define_interface') to "Define MATLAB Interface for C++ Library".



%% Setup
% Do not edit this setup section.
function libDef = defineMyCppLib()
libDef = clibgen.LibraryDefinition("MyCppLibData.xml");

%% OutputFolder and Libraries 
libDef.OutputFolder = "";
% libDef.Libraries = "C:\Users\morle\OneDrive\Documents\tsagi25\lusbapi\DLL\Bin\Lusbapi64.dll";
%libDef.Libraries = ".\Lusbapi64.dll";
libDef.OutputFolder = "";
libDef.Libraries = "MyCppLib\Lusbapi64.dll";

%% C++ class |typedef void* HANDLE| with MATLAB name |clib.MyCppLib.HANDLE| 
addOpaqueType(libDef, "typedef void* HANDLE", "MATLABName", "clib.MyCppLib.HANDLE", ...
    "Description", "clib.MyCppLib.HANDLE    C++ opaque type."); % Modify help description values as needed.

%% C++ class |typedef void* LPVOID| with MATLAB name |clib.MyCppLib.LPVOID| 
addOpaqueType(libDef, "typedef void* LPVOID", "MATLABName", "clib.MyCppLib.LPVOID", ...
    "Description", "clib.MyCppLib.LPVOID    C++ opaque type."); % Modify help description values as needed.

%% C++ class |IO_REQUEST_LUSBAPI| with MATLAB name |clib.MyCppLib.IO_REQUEST_LUSBAPI| 
IO_REQUEST_LUSBAPIDefinition = addClass(libDef, "IO_REQUEST_LUSBAPI", "MATLABName", "clib.MyCppLib.IO_REQUEST_LUSBAPI", ...
    "Description", "clib.MyCppLib.IO_REQUEST_LUSBAPI    Representation of C++ class IO_REQUEST_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |IO_REQUEST_LUSBAPI| 
% C++ Signature: IO_REQUEST_LUSBAPI::IO_REQUEST_LUSBAPI(IO_REQUEST_LUSBAPI const & input1)

IO_REQUEST_LUSBAPIConstructor1Definition = addConstructor(IO_REQUEST_LUSBAPIDefinition, ...
    "IO_REQUEST_LUSBAPI::IO_REQUEST_LUSBAPI(IO_REQUEST_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.IO_REQUEST_LUSBAPI Constructor of C++ class IO_REQUEST_LUSBAPI."); % Modify help description values as needed.
defineArgument(IO_REQUEST_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input");
validate(IO_REQUEST_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |IO_REQUEST_LUSBAPI| 
% C++ Signature: IO_REQUEST_LUSBAPI::IO_REQUEST_LUSBAPI()

IO_REQUEST_LUSBAPIConstructor2Definition = addConstructor(IO_REQUEST_LUSBAPIDefinition, ...
    "IO_REQUEST_LUSBAPI::IO_REQUEST_LUSBAPI()", ...
    "Description", "clib.MyCppLib.IO_REQUEST_LUSBAPI Constructor of C++ class IO_REQUEST_LUSBAPI."); % Modify help description values as needed.
validate(IO_REQUEST_LUSBAPIConstructor2Definition);

%% C++ class public data member |Buffer| for C++ class |IO_REQUEST_LUSBAPI| 
% C++ Signature: SHORT * IO_REQUEST_LUSBAPI::Buffer

addProperty(IO_REQUEST_LUSBAPIDefinition, "Buffer", "int16", 1,... % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
   "Description", "clib.array.MyCppLib.Short    Data member of C++ class IO_REQUEST_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |NumberOfWordsToPass| for C++ class |IO_REQUEST_LUSBAPI| 
% C++ Signature: DWORD IO_REQUEST_LUSBAPI::NumberOfWordsToPass

addProperty(IO_REQUEST_LUSBAPIDefinition, "NumberOfWordsToPass", "uint32", ...
    "Description", "uint32    Data member of C++ class IO_REQUEST_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |NumberOfWordsPassed| for C++ class |IO_REQUEST_LUSBAPI| 
% C++ Signature: DWORD IO_REQUEST_LUSBAPI::NumberOfWordsPassed

addProperty(IO_REQUEST_LUSBAPIDefinition, "NumberOfWordsPassed", "uint32", ...
    "Description", "uint32    Data member of C++ class IO_REQUEST_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |TimeOut| for C++ class |IO_REQUEST_LUSBAPI| 
% C++ Signature: DWORD IO_REQUEST_LUSBAPI::TimeOut

addProperty(IO_REQUEST_LUSBAPIDefinition, "TimeOut", "uint32", ...
    "Description", "uint32    Data member of C++ class IO_REQUEST_LUSBAPI."); % Modify help description values as needed.

%% C++ class |LAST_ERROR_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.LAST_ERROR_INFO_LUSBAPI| 
LAST_ERROR_INFO_LUSBAPIDefinition = addClass(libDef, "LAST_ERROR_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.LAST_ERROR_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.LAST_ERROR_INFO_LUSBAPI    Representation of C++ class LAST_ERROR_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |LAST_ERROR_INFO_LUSBAPI| 
% C++ Signature: LAST_ERROR_INFO_LUSBAPI::LAST_ERROR_INFO_LUSBAPI(LAST_ERROR_INFO_LUSBAPI const & input1)

LAST_ERROR_INFO_LUSBAPIConstructor1Definition = addConstructor(LAST_ERROR_INFO_LUSBAPIDefinition, ...
    "LAST_ERROR_INFO_LUSBAPI::LAST_ERROR_INFO_LUSBAPI(LAST_ERROR_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.LAST_ERROR_INFO_LUSBAPI Constructor of C++ class LAST_ERROR_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(LAST_ERROR_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.LAST_ERROR_INFO_LUSBAPI", "input");
validate(LAST_ERROR_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |LAST_ERROR_INFO_LUSBAPI| 
% C++ Signature: LAST_ERROR_INFO_LUSBAPI::LAST_ERROR_INFO_LUSBAPI()

LAST_ERROR_INFO_LUSBAPIConstructor2Definition = addConstructor(LAST_ERROR_INFO_LUSBAPIDefinition, ...
    "LAST_ERROR_INFO_LUSBAPI::LAST_ERROR_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.LAST_ERROR_INFO_LUSBAPI Constructor of C++ class LAST_ERROR_INFO_LUSBAPI."); % Modify help description values as needed.
validate(LAST_ERROR_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |ErrorString| for C++ class |LAST_ERROR_INFO_LUSBAPI| 
% C++ Signature: BYTE [256] LAST_ERROR_INFO_LUSBAPI::ErrorString

addProperty(LAST_ERROR_INFO_LUSBAPIDefinition, "ErrorString", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class LAST_ERROR_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |ErrorNumber| for C++ class |LAST_ERROR_INFO_LUSBAPI| 
% C++ Signature: DWORD LAST_ERROR_INFO_LUSBAPI::ErrorNumber

addProperty(LAST_ERROR_INFO_LUSBAPIDefinition, "ErrorNumber", "uint32", ...
    "Description", "uint32    Data member of C++ class LAST_ERROR_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |VERSION_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.VERSION_INFO_LUSBAPI| 
VERSION_INFO_LUSBAPIDefinition = addClass(libDef, "VERSION_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.VERSION_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.VERSION_INFO_LUSBAPI    Representation of C++ class VERSION_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |VERSION_INFO_LUSBAPI| 
% C++ Signature: VERSION_INFO_LUSBAPI::VERSION_INFO_LUSBAPI(VERSION_INFO_LUSBAPI const & input1)

VERSION_INFO_LUSBAPIConstructor1Definition = addConstructor(VERSION_INFO_LUSBAPIDefinition, ...
    "VERSION_INFO_LUSBAPI::VERSION_INFO_LUSBAPI(VERSION_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.VERSION_INFO_LUSBAPI Constructor of C++ class VERSION_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(VERSION_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.VERSION_INFO_LUSBAPI", "input");
validate(VERSION_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |VERSION_INFO_LUSBAPI| 
% C++ Signature: VERSION_INFO_LUSBAPI::VERSION_INFO_LUSBAPI()

VERSION_INFO_LUSBAPIConstructor2Definition = addConstructor(VERSION_INFO_LUSBAPIDefinition, ...
    "VERSION_INFO_LUSBAPI::VERSION_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.VERSION_INFO_LUSBAPI Constructor of C++ class VERSION_INFO_LUSBAPI."); % Modify help description values as needed.
validate(VERSION_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |Version| for C++ class |VERSION_INFO_LUSBAPI| 
% C++ Signature: BYTE [10] VERSION_INFO_LUSBAPI::Version

addProperty(VERSION_INFO_LUSBAPIDefinition, "Version", "clib.array.MyCppLib.UnsignedChar", [10], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class VERSION_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Date| for C++ class |VERSION_INFO_LUSBAPI| 
% C++ Signature: BYTE [14] VERSION_INFO_LUSBAPI::Date

addProperty(VERSION_INFO_LUSBAPIDefinition, "Date", "clib.array.MyCppLib.UnsignedChar", [14], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class VERSION_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Manufacturer| for C++ class |VERSION_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] VERSION_INFO_LUSBAPI::Manufacturer

addProperty(VERSION_INFO_LUSBAPIDefinition, "Manufacturer", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class VERSION_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Author| for C++ class |VERSION_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] VERSION_INFO_LUSBAPI::Author

addProperty(VERSION_INFO_LUSBAPIDefinition, "Author", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class VERSION_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |VERSION_INFO_LUSBAPI| 
% C++ Signature: BYTE [256] VERSION_INFO_LUSBAPI::Comment

addProperty(VERSION_INFO_LUSBAPIDefinition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class VERSION_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |MCU_VERSION_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.MCU_VERSION_INFO_LUSBAPI| 
MCU_VERSION_INFO_LUSBAPIDefinition = addClass(libDef, "MCU_VERSION_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.MCU_VERSION_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.MCU_VERSION_INFO_LUSBAPI    Representation of C++ class MCU_VERSION_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |MCU_VERSION_INFO_LUSBAPI| 
% C++ Signature: MCU_VERSION_INFO_LUSBAPI::MCU_VERSION_INFO_LUSBAPI(MCU_VERSION_INFO_LUSBAPI const & input1)

MCU_VERSION_INFO_LUSBAPIConstructor1Definition = addConstructor(MCU_VERSION_INFO_LUSBAPIDefinition, ...
    "MCU_VERSION_INFO_LUSBAPI::MCU_VERSION_INFO_LUSBAPI(MCU_VERSION_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.MCU_VERSION_INFO_LUSBAPI Constructor of C++ class MCU_VERSION_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(MCU_VERSION_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.MCU_VERSION_INFO_LUSBAPI", "input");
validate(MCU_VERSION_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |MCU_VERSION_INFO_LUSBAPI| 
% C++ Signature: MCU_VERSION_INFO_LUSBAPI::MCU_VERSION_INFO_LUSBAPI()

MCU_VERSION_INFO_LUSBAPIConstructor2Definition = addConstructor(MCU_VERSION_INFO_LUSBAPIDefinition, ...
    "MCU_VERSION_INFO_LUSBAPI::MCU_VERSION_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.MCU_VERSION_INFO_LUSBAPI Constructor of C++ class MCU_VERSION_INFO_LUSBAPI."); % Modify help description values as needed.
validate(MCU_VERSION_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |FwVersion| for C++ class |MCU_VERSION_INFO_LUSBAPI| 
% C++ Signature: VERSION_INFO_LUSBAPI MCU_VERSION_INFO_LUSBAPI::FwVersion

addProperty(MCU_VERSION_INFO_LUSBAPIDefinition, "FwVersion", "clib.MyCppLib.VERSION_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.VERSION_INFO_LUSBAPI    Data member of C++ class MCU_VERSION_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |BlVersion| for C++ class |MCU_VERSION_INFO_LUSBAPI| 
% C++ Signature: VERSION_INFO_LUSBAPI MCU_VERSION_INFO_LUSBAPI::BlVersion

addProperty(MCU_VERSION_INFO_LUSBAPIDefinition, "BlVersion", "clib.MyCppLib.VERSION_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.VERSION_INFO_LUSBAPI    Data member of C++ class MCU_VERSION_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |MODULE_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.MODULE_INFO_LUSBAPI| 
MODULE_INFO_LUSBAPIDefinition = addClass(libDef, "MODULE_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.MODULE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.MODULE_INFO_LUSBAPI    Representation of C++ class MODULE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |MODULE_INFO_LUSBAPI| 
% C++ Signature: MODULE_INFO_LUSBAPI::MODULE_INFO_LUSBAPI(MODULE_INFO_LUSBAPI const & input1)

MODULE_INFO_LUSBAPIConstructor1Definition = addConstructor(MODULE_INFO_LUSBAPIDefinition, ...
    "MODULE_INFO_LUSBAPI::MODULE_INFO_LUSBAPI(MODULE_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.MODULE_INFO_LUSBAPI Constructor of C++ class MODULE_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(MODULE_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.MODULE_INFO_LUSBAPI", "input");
validate(MODULE_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |MODULE_INFO_LUSBAPI| 
% C++ Signature: MODULE_INFO_LUSBAPI::MODULE_INFO_LUSBAPI()

MODULE_INFO_LUSBAPIConstructor2Definition = addConstructor(MODULE_INFO_LUSBAPIDefinition, ...
    "MODULE_INFO_LUSBAPI::MODULE_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.MODULE_INFO_LUSBAPI Constructor of C++ class MODULE_INFO_LUSBAPI."); % Modify help description values as needed.
validate(MODULE_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |CompanyName| for C++ class |MODULE_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] MODULE_INFO_LUSBAPI::CompanyName

addProperty(MODULE_INFO_LUSBAPIDefinition, "CompanyName", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class MODULE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |DeviceName| for C++ class |MODULE_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] MODULE_INFO_LUSBAPI::DeviceName

addProperty(MODULE_INFO_LUSBAPIDefinition, "DeviceName", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class MODULE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |SerialNumber| for C++ class |MODULE_INFO_LUSBAPI| 
% C++ Signature: BYTE [16] MODULE_INFO_LUSBAPI::SerialNumber

addProperty(MODULE_INFO_LUSBAPIDefinition, "SerialNumber", "clib.array.MyCppLib.UnsignedChar", [16], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class MODULE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Revision| for C++ class |MODULE_INFO_LUSBAPI| 
% C++ Signature: BYTE MODULE_INFO_LUSBAPI::Revision

addProperty(MODULE_INFO_LUSBAPIDefinition, "Revision", "uint8", ...
    "Description", "uint8    Data member of C++ class MODULE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Modification| for C++ class |MODULE_INFO_LUSBAPI| 
% C++ Signature: BYTE MODULE_INFO_LUSBAPI::Modification

addProperty(MODULE_INFO_LUSBAPIDefinition, "Modification", "uint8", ...
    "Description", "uint8    Data member of C++ class MODULE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |MODULE_INFO_LUSBAPI| 
% C++ Signature: BYTE [256] MODULE_INFO_LUSBAPI::Comment

addProperty(MODULE_INFO_LUSBAPIDefinition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class MODULE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |DSP_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.DSP_INFO_LUSBAPI| 
DSP_INFO_LUSBAPIDefinition = addClass(libDef, "DSP_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.DSP_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DSP_INFO_LUSBAPI    Representation of C++ class DSP_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |DSP_INFO_LUSBAPI| 
% C++ Signature: DSP_INFO_LUSBAPI::DSP_INFO_LUSBAPI(DSP_INFO_LUSBAPI const & input1)

DSP_INFO_LUSBAPIConstructor1Definition = addConstructor(DSP_INFO_LUSBAPIDefinition, ...
    "DSP_INFO_LUSBAPI::DSP_INFO_LUSBAPI(DSP_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.DSP_INFO_LUSBAPI Constructor of C++ class DSP_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(DSP_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.DSP_INFO_LUSBAPI", "input");
validate(DSP_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |DSP_INFO_LUSBAPI| 
% C++ Signature: DSP_INFO_LUSBAPI::DSP_INFO_LUSBAPI()

DSP_INFO_LUSBAPIConstructor2Definition = addConstructor(DSP_INFO_LUSBAPIDefinition, ...
    "DSP_INFO_LUSBAPI::DSP_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.DSP_INFO_LUSBAPI Constructor of C++ class DSP_INFO_LUSBAPI."); % Modify help description values as needed.
validate(DSP_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |Active| for C++ class |DSP_INFO_LUSBAPI| 
% C++ Signature: BOOL DSP_INFO_LUSBAPI::Active

addProperty(DSP_INFO_LUSBAPIDefinition, "Active", "int32", ...
    "Description", "int32    Data member of C++ class DSP_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Name| for C++ class |DSP_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] DSP_INFO_LUSBAPI::Name

addProperty(DSP_INFO_LUSBAPIDefinition, "Name", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class DSP_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |ClockRate| for C++ class |DSP_INFO_LUSBAPI| 
% C++ Signature: double DSP_INFO_LUSBAPI::ClockRate

addProperty(DSP_INFO_LUSBAPIDefinition, "ClockRate", "double", ...
    "Description", "double    Data member of C++ class DSP_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Version| for C++ class |DSP_INFO_LUSBAPI| 
% C++ Signature: VERSION_INFO_LUSBAPI DSP_INFO_LUSBAPI::Version

addProperty(DSP_INFO_LUSBAPIDefinition, "Version", "clib.MyCppLib.VERSION_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.VERSION_INFO_LUSBAPI    Data member of C++ class DSP_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |DSP_INFO_LUSBAPI| 
% C++ Signature: BYTE [256] DSP_INFO_LUSBAPI::Comment

addProperty(DSP_INFO_LUSBAPIDefinition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class DSP_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |PLD_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.PLD_INFO_LUSBAPI| 
PLD_INFO_LUSBAPIDefinition = addClass(libDef, "PLD_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.PLD_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.PLD_INFO_LUSBAPI    Representation of C++ class PLD_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |PLD_INFO_LUSBAPI| 
% C++ Signature: PLD_INFO_LUSBAPI::PLD_INFO_LUSBAPI(PLD_INFO_LUSBAPI const & input1)

PLD_INFO_LUSBAPIConstructor1Definition = addConstructor(PLD_INFO_LUSBAPIDefinition, ...
    "PLD_INFO_LUSBAPI::PLD_INFO_LUSBAPI(PLD_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.PLD_INFO_LUSBAPI Constructor of C++ class PLD_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(PLD_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.PLD_INFO_LUSBAPI", "input");
validate(PLD_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |PLD_INFO_LUSBAPI| 
% C++ Signature: PLD_INFO_LUSBAPI::PLD_INFO_LUSBAPI()

PLD_INFO_LUSBAPIConstructor2Definition = addConstructor(PLD_INFO_LUSBAPIDefinition, ...
    "PLD_INFO_LUSBAPI::PLD_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.PLD_INFO_LUSBAPI Constructor of C++ class PLD_INFO_LUSBAPI."); % Modify help description values as needed.
validate(PLD_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |Active| for C++ class |PLD_INFO_LUSBAPI| 
% C++ Signature: BOOL PLD_INFO_LUSBAPI::Active

addProperty(PLD_INFO_LUSBAPIDefinition, "Active", "int32", ...
    "Description", "int32    Data member of C++ class PLD_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Name| for C++ class |PLD_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] PLD_INFO_LUSBAPI::Name

addProperty(PLD_INFO_LUSBAPIDefinition, "Name", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class PLD_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |ClockRate| for C++ class |PLD_INFO_LUSBAPI| 
% C++ Signature: double PLD_INFO_LUSBAPI::ClockRate

addProperty(PLD_INFO_LUSBAPIDefinition, "ClockRate", "double", ...
    "Description", "double    Data member of C++ class PLD_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Version| for C++ class |PLD_INFO_LUSBAPI| 
% C++ Signature: VERSION_INFO_LUSBAPI PLD_INFO_LUSBAPI::Version

addProperty(PLD_INFO_LUSBAPIDefinition, "Version", "clib.MyCppLib.VERSION_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.VERSION_INFO_LUSBAPI    Data member of C++ class PLD_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |PLD_INFO_LUSBAPI| 
% C++ Signature: BYTE [256] PLD_INFO_LUSBAPI::Comment

addProperty(PLD_INFO_LUSBAPIDefinition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class PLD_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |ADC_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.ADC_INFO_LUSBAPI| 
ADC_INFO_LUSBAPIDefinition = addClass(libDef, "ADC_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.ADC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.ADC_INFO_LUSBAPI    Representation of C++ class ADC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |ADC_INFO_LUSBAPI| 
% C++ Signature: ADC_INFO_LUSBAPI::ADC_INFO_LUSBAPI(ADC_INFO_LUSBAPI const & input1)

ADC_INFO_LUSBAPIConstructor1Definition = addConstructor(ADC_INFO_LUSBAPIDefinition, ...
    "ADC_INFO_LUSBAPI::ADC_INFO_LUSBAPI(ADC_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.ADC_INFO_LUSBAPI Constructor of C++ class ADC_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(ADC_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.ADC_INFO_LUSBAPI", "input");
validate(ADC_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |ADC_INFO_LUSBAPI| 
% C++ Signature: ADC_INFO_LUSBAPI::ADC_INFO_LUSBAPI()

ADC_INFO_LUSBAPIConstructor2Definition = addConstructor(ADC_INFO_LUSBAPIDefinition, ...
    "ADC_INFO_LUSBAPI::ADC_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.ADC_INFO_LUSBAPI Constructor of C++ class ADC_INFO_LUSBAPI."); % Modify help description values as needed.
validate(ADC_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |Active| for C++ class |ADC_INFO_LUSBAPI| 
% C++ Signature: BOOL ADC_INFO_LUSBAPI::Active

addProperty(ADC_INFO_LUSBAPIDefinition, "Active", "int32", ...
    "Description", "int32    Data member of C++ class ADC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Name| for C++ class |ADC_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] ADC_INFO_LUSBAPI::Name

addProperty(ADC_INFO_LUSBAPIDefinition, "Name", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class ADC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |OffsetCalibration| for C++ class |ADC_INFO_LUSBAPI| 
% C++ Signature: double [128] ADC_INFO_LUSBAPI::OffsetCalibration

addProperty(ADC_INFO_LUSBAPIDefinition, "OffsetCalibration", "clib.array.MyCppLib.Double", [128], ... % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
    "Description", "clib.array.MyCppLib.Double    Data member of C++ class ADC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |ScaleCalibration| for C++ class |ADC_INFO_LUSBAPI| 
% C++ Signature: double [128] ADC_INFO_LUSBAPI::ScaleCalibration

addProperty(ADC_INFO_LUSBAPIDefinition, "ScaleCalibration", "clib.array.MyCppLib.Double", [128], ... % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
    "Description", "clib.array.MyCppLib.Double    Data member of C++ class ADC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |ADC_INFO_LUSBAPI| 
% C++ Signature: BYTE [256] ADC_INFO_LUSBAPI::Comment

addProperty(ADC_INFO_LUSBAPIDefinition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class ADC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |DAC_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.DAC_INFO_LUSBAPI| 
DAC_INFO_LUSBAPIDefinition = addClass(libDef, "DAC_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.DAC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DAC_INFO_LUSBAPI    Representation of C++ class DAC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |DAC_INFO_LUSBAPI| 
% C++ Signature: DAC_INFO_LUSBAPI::DAC_INFO_LUSBAPI(DAC_INFO_LUSBAPI const & input1)

DAC_INFO_LUSBAPIConstructor1Definition = addConstructor(DAC_INFO_LUSBAPIDefinition, ...
    "DAC_INFO_LUSBAPI::DAC_INFO_LUSBAPI(DAC_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.DAC_INFO_LUSBAPI Constructor of C++ class DAC_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(DAC_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.DAC_INFO_LUSBAPI", "input");
validate(DAC_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |DAC_INFO_LUSBAPI| 
% C++ Signature: DAC_INFO_LUSBAPI::DAC_INFO_LUSBAPI()

DAC_INFO_LUSBAPIConstructor2Definition = addConstructor(DAC_INFO_LUSBAPIDefinition, ...
    "DAC_INFO_LUSBAPI::DAC_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.DAC_INFO_LUSBAPI Constructor of C++ class DAC_INFO_LUSBAPI."); % Modify help description values as needed.
validate(DAC_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |Active| for C++ class |DAC_INFO_LUSBAPI| 
% C++ Signature: BOOL DAC_INFO_LUSBAPI::Active

addProperty(DAC_INFO_LUSBAPIDefinition, "Active", "int32", ...
    "Description", "int32    Data member of C++ class DAC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Name| for C++ class |DAC_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] DAC_INFO_LUSBAPI::Name

addProperty(DAC_INFO_LUSBAPIDefinition, "Name", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class DAC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |OffsetCalibration| for C++ class |DAC_INFO_LUSBAPI| 
% C++ Signature: double [128] DAC_INFO_LUSBAPI::OffsetCalibration

addProperty(DAC_INFO_LUSBAPIDefinition, "OffsetCalibration", "clib.array.MyCppLib.Double", [128], ... % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
    "Description", "clib.array.MyCppLib.Double    Data member of C++ class DAC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |ScaleCalibration| for C++ class |DAC_INFO_LUSBAPI| 
% C++ Signature: double [128] DAC_INFO_LUSBAPI::ScaleCalibration

addProperty(DAC_INFO_LUSBAPIDefinition, "ScaleCalibration", "clib.array.MyCppLib.Double", [128], ... % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
    "Description", "clib.array.MyCppLib.Double    Data member of C++ class DAC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |DAC_INFO_LUSBAPI| 
% C++ Signature: BYTE [256] DAC_INFO_LUSBAPI::Comment

addProperty(DAC_INFO_LUSBAPIDefinition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class DAC_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |DIGITAL_IO_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI| 
DIGITAL_IO_INFO_LUSBAPIDefinition = addClass(libDef, "DIGITAL_IO_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI    Representation of C++ class DIGITAL_IO_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |DIGITAL_IO_INFO_LUSBAPI| 
% C++ Signature: DIGITAL_IO_INFO_LUSBAPI::DIGITAL_IO_INFO_LUSBAPI(DIGITAL_IO_INFO_LUSBAPI const & input1)

DIGITAL_IO_INFO_LUSBAPIConstructor1Definition = addConstructor(DIGITAL_IO_INFO_LUSBAPIDefinition, ...
    "DIGITAL_IO_INFO_LUSBAPI::DIGITAL_IO_INFO_LUSBAPI(DIGITAL_IO_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI Constructor of C++ class DIGITAL_IO_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(DIGITAL_IO_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI", "input");
validate(DIGITAL_IO_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |DIGITAL_IO_INFO_LUSBAPI| 
% C++ Signature: DIGITAL_IO_INFO_LUSBAPI::DIGITAL_IO_INFO_LUSBAPI()

DIGITAL_IO_INFO_LUSBAPIConstructor2Definition = addConstructor(DIGITAL_IO_INFO_LUSBAPIDefinition, ...
    "DIGITAL_IO_INFO_LUSBAPI::DIGITAL_IO_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI Constructor of C++ class DIGITAL_IO_INFO_LUSBAPI."); % Modify help description values as needed.
validate(DIGITAL_IO_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |Active| for C++ class |DIGITAL_IO_INFO_LUSBAPI| 
% C++ Signature: BOOL DIGITAL_IO_INFO_LUSBAPI::Active

addProperty(DIGITAL_IO_INFO_LUSBAPIDefinition, "Active", "int32", ...
    "Description", "int32    Data member of C++ class DIGITAL_IO_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Name| for C++ class |DIGITAL_IO_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] DIGITAL_IO_INFO_LUSBAPI::Name

addProperty(DIGITAL_IO_INFO_LUSBAPIDefinition, "Name", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class DIGITAL_IO_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |InLinesQuantity| for C++ class |DIGITAL_IO_INFO_LUSBAPI| 
% C++ Signature: WORD DIGITAL_IO_INFO_LUSBAPI::InLinesQuantity

addProperty(DIGITAL_IO_INFO_LUSBAPIDefinition, "InLinesQuantity", "uint16", ...
    "Description", "uint16    Data member of C++ class DIGITAL_IO_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |OutLinesQuantity| for C++ class |DIGITAL_IO_INFO_LUSBAPI| 
% C++ Signature: WORD DIGITAL_IO_INFO_LUSBAPI::OutLinesQuantity

addProperty(DIGITAL_IO_INFO_LUSBAPIDefinition, "OutLinesQuantity", "uint16", ...
    "Description", "uint16    Data member of C++ class DIGITAL_IO_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |DIGITAL_IO_INFO_LUSBAPI| 
% C++ Signature: BYTE [256] DIGITAL_IO_INFO_LUSBAPI::Comment

addProperty(DIGITAL_IO_INFO_LUSBAPIDefinition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class DIGITAL_IO_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |INTERFACE_INFO_LUSBAPI| with MATLAB name |clib.MyCppLib.INTERFACE_INFO_LUSBAPI| 
INTERFACE_INFO_LUSBAPIDefinition = addClass(libDef, "INTERFACE_INFO_LUSBAPI", "MATLABName", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI    Representation of C++ class INTERFACE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class constructor for C++ class |INTERFACE_INFO_LUSBAPI| 
% C++ Signature: INTERFACE_INFO_LUSBAPI::INTERFACE_INFO_LUSBAPI(INTERFACE_INFO_LUSBAPI const & input1)

INTERFACE_INFO_LUSBAPIConstructor1Definition = addConstructor(INTERFACE_INFO_LUSBAPIDefinition, ...
    "INTERFACE_INFO_LUSBAPI::INTERFACE_INFO_LUSBAPI(INTERFACE_INFO_LUSBAPI const & input1)", ...
    "Description", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI Constructor of C++ class INTERFACE_INFO_LUSBAPI."); % Modify help description values as needed.
defineArgument(INTERFACE_INFO_LUSBAPIConstructor1Definition, "input1", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI", "input");
validate(INTERFACE_INFO_LUSBAPIConstructor1Definition);

%% C++ class constructor for C++ class |INTERFACE_INFO_LUSBAPI| 
% C++ Signature: INTERFACE_INFO_LUSBAPI::INTERFACE_INFO_LUSBAPI()

INTERFACE_INFO_LUSBAPIConstructor2Definition = addConstructor(INTERFACE_INFO_LUSBAPIDefinition, ...
    "INTERFACE_INFO_LUSBAPI::INTERFACE_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI Constructor of C++ class INTERFACE_INFO_LUSBAPI."); % Modify help description values as needed.
validate(INTERFACE_INFO_LUSBAPIConstructor2Definition);

%% C++ class public data member |Active| for C++ class |INTERFACE_INFO_LUSBAPI| 
% C++ Signature: BOOL INTERFACE_INFO_LUSBAPI::Active

addProperty(INTERFACE_INFO_LUSBAPIDefinition, "Active", "int32", ...
    "Description", "int32    Data member of C++ class INTERFACE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Name| for C++ class |INTERFACE_INFO_LUSBAPI| 
% C++ Signature: BYTE [25] INTERFACE_INFO_LUSBAPI::Name

addProperty(INTERFACE_INFO_LUSBAPIDefinition, "Name", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class INTERFACE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |INTERFACE_INFO_LUSBAPI| 
% C++ Signature: BYTE [256] INTERFACE_INFO_LUSBAPI::Comment

addProperty(INTERFACE_INFO_LUSBAPIDefinition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class INTERFACE_INFO_LUSBAPI."); % Modify help description values as needed.

%% C++ class |ILUSBBASE| with MATLAB name |clib.MyCppLib.ILUSBBASE| 
ILUSBBASEDefinition = addClass(libDef, "ILUSBBASE", "MATLABName", "clib.MyCppLib.ILUSBBASE", ...
    "Description", "clib.MyCppLib.ILUSBBASE    Representation of C++ class ILUSBBASE."); % Modify help description values as needed.

%% C++ class method |OpenLDevice| for C++ class |ILUSBBASE| 
% C++ Signature: BOOL ILUSBBASE::OpenLDevice(WORD VirtualSlot)

OpenLDeviceDefinition = addMethod(ILUSBBASEDefinition, ...
    "BOOL ILUSBBASE::OpenLDevice(WORD VirtualSlot)", ...
    "MATLABName", "OpenLDevice", ...
    "Description", "OpenLDevice Method of C++ class ILUSBBASE."); % Modify help description values as needed.
defineArgument(OpenLDeviceDefinition, "VirtualSlot", "uint16");
defineOutput(OpenLDeviceDefinition, "RetVal", "int32");
validate(OpenLDeviceDefinition);

%% C++ class method |CloseLDevice| for C++ class |ILUSBBASE| 
% C++ Signature: BOOL ILUSBBASE::CloseLDevice()

CloseLDeviceDefinition = addMethod(ILUSBBASEDefinition, ...
    "BOOL ILUSBBASE::CloseLDevice()", ...
    "MATLABName", "CloseLDevice", ...
    "Description", "CloseLDevice Method of C++ class ILUSBBASE."); % Modify help description values as needed.
defineOutput(CloseLDeviceDefinition, "RetVal", "int32");
validate(CloseLDeviceDefinition);

%% C++ class method |ReleaseLInstance| for C++ class |ILUSBBASE| 
% C++ Signature: BOOL ILUSBBASE::ReleaseLInstance()

ReleaseLInstanceDefinition = addMethod(ILUSBBASEDefinition, ...
    "BOOL ILUSBBASE::ReleaseLInstance()", ...
    "MATLABName", "ReleaseLInstance", ...
    "Description", "ReleaseLInstance Method of C++ class ILUSBBASE."); % Modify help description values as needed.
defineOutput(ReleaseLInstanceDefinition, "RetVal", "int32");
validate(ReleaseLInstanceDefinition);

%% C++ class method |GetModuleHandleA| for C++ class |ILUSBBASE| 
% C++ Signature: HANDLE ILUSBBASE::GetModuleHandleA()

GetModuleHandleADefinition = addMethod(ILUSBBASEDefinition, ...
    "HANDLE ILUSBBASE::GetModuleHandleA()", ...
    "MATLABName", "GetModuleHandleA", ...
    "Description", "GetModuleHandleA Method of C++ class ILUSBBASE."); % Modify help description values as needed.
defineOutput(GetModuleHandleADefinition, "RetVal", "clib.MyCppLib.HANDLE", 1);
validate(GetModuleHandleADefinition);

%% C++ class method |GetModuleName| for C++ class |ILUSBBASE| 
%C++ Signature: BOOL ILUSBBASE::GetModuleName(char * const ModuleName)

GetModuleNameDefinition = addMethod(ILUSBBASEDefinition, ...
   "BOOL ILUSBBASE::GetModuleName(char * const ModuleName)", ...
   "MATLABName", "GetModuleName", ...
   "Description", "GetModuleName Method of C++ class ILUSBBASE."); % Modify help description values as needed.
defineArgument(GetModuleNameDefinition, "ModuleName", "clib.array.MyCppLib.Char", "input",7); % <MLTYPE> can be "clib.array.MyCppLib.Char","int8","string", or "char"
defineOutput(GetModuleNameDefinition, "RetVal", "int32");
validate(GetModuleNameDefinition);

%% C++ class method |GetUsbSpeed| for C++ class |ILUSBBASE| 
% C++ Signature: BOOL ILUSBBASE::GetUsbSpeed(BYTE * const UsbSpeed)

GetUsbSpeedDefinition = addMethod(ILUSBBASEDefinition, ...
   "BOOL ILUSBBASE::GetUsbSpeed(BYTE * const UsbSpeed)", ...
   "MATLABName", "GetUsbSpeed", ...
   "Description", "GetUsbSpeed Method of C++ class ILUSBBASE."); % Modify help description values as needed.
defineArgument(GetUsbSpeedDefinition, "UsbSpeed", "uint8", "input", 1); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
defineOutput(GetUsbSpeedDefinition, "RetVal", "int32");
validate(GetUsbSpeedDefinition);

%% C++ class method |LowPowerMode| for C++ class |ILUSBBASE| 
% C++ Signature: BOOL ILUSBBASE::LowPowerMode(BOOL LowPowerFlag)

LowPowerModeDefinition = addMethod(ILUSBBASEDefinition, ...
    "BOOL ILUSBBASE::LowPowerMode(BOOL LowPowerFlag)", ...
    "MATLABName", "LowPowerMode", ...
    "Description", "LowPowerMode Method of C++ class ILUSBBASE."); % Modify help description values as needed.
defineArgument(LowPowerModeDefinition, "LowPowerFlag", "int32");
defineOutput(LowPowerModeDefinition, "RetVal", "int32");
validate(LowPowerModeDefinition);

%% C++ class method |GetLastErrorInfo| for C++ class |ILUSBBASE| 
% C++ Signature: BOOL ILUSBBASE::GetLastErrorInfo(LAST_ERROR_INFO_LUSBAPI * const LastErrorInfo)

GetLastErrorInfoDefinition = addMethod(ILUSBBASEDefinition, ...
   "BOOL ILUSBBASE::GetLastErrorInfo(LAST_ERROR_INFO_LUSBAPI * const LastErrorInfo)", ...
   "MATLABName", "GetLastErrorInfo", ...
   "Description", "GetLastErrorInfo Method of C++ class ILUSBBASE."); % Modify help description values as needed.
defineArgument(GetLastErrorInfoDefinition, "LastErrorInfo", "clib.MyCppLib.LAST_ERROR_INFO_LUSBAPI", "input", 1); % <MLTYPE> can be "clib.MyCppLib.LAST_ERROR_INFO_LUSBAPI", or "clib.array.MyCppLib.LAST_ERROR_INFO_LUSBAPI"
defineOutput(GetLastErrorInfoDefinition, "RetVal", "int32");
validate(GetLastErrorInfoDefinition);

%% C++ class |MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>| with MATLAB name |clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_| 
MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_Definition = addClass(libDef, "MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>", "MATLABName", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_    Representation of C++ class MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class constructor for C++ class |MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>| 
% C++ Signature: MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>::MCU_INFO_LUSBAPI(MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI> const & input1)

MCU_INFO_LUSBAPI_VERSION_INFO_LUConstructor1Definition = addConstructor(MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_Definition, ...
    "MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>::MCU_INFO_LUSBAPI(MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI> const & input1)", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_ Constructor of C++ class MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.
defineArgument(MCU_INFO_LUSBAPI_VERSION_INFO_LUConstructor1Definition, "input1", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_", "input");
validate(MCU_INFO_LUSBAPI_VERSION_INFO_LUConstructor1Definition);

%% C++ class constructor for C++ class |MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>| 
% C++ Signature: MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>::MCU_INFO_LUSBAPI()

MCU_INFO_LUSBAPI_VERSION_INFO_LUConstructor2Definition = addConstructor(MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_Definition, ...
    "MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>::MCU_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_ Constructor of C++ class MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.
validate(MCU_INFO_LUSBAPI_VERSION_INFO_LUConstructor2Definition);

%% C++ class public data member |Active| for C++ class |MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>| 
% C++ Signature: BOOL MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>::Active

addProperty(MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_Definition, "Active", "int32", ...
    "Description", "int32    Data member of C++ class MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class public data member |Name| for C++ class |MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>| 
% C++ Signature: BYTE [25] MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>::Name

addProperty(MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_Definition, "Name", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class public data member |ClockRate| for C++ class |MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>| 
% C++ Signature: double MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>::ClockRate

addProperty(MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_Definition, "ClockRate", "double", ...
    "Description", "double    Data member of C++ class MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class public data member |Version| for C++ class |MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>| 
% C++ Signature: VERSION_INFO_LUSBAPI MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>::Version

addProperty(MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_Definition, "Version", "clib.MyCppLib.VERSION_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.VERSION_INFO_LUSBAPI    Data member of C++ class MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>| 
% C++ Signature: BYTE [256] MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>::Comment

addProperty(MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_Definition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class |MODULE_DESCRIPTION_E140| with MATLAB name |clib.MyCppLib.MODULE_DESCRIPTION_E140| 
MODULE_DESCRIPTION_E140Definition = addClass(libDef, "MODULE_DESCRIPTION_E140", "MATLABName", "clib.MyCppLib.MODULE_DESCRIPTION_E140", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E140    Representation of C++ class MODULE_DESCRIPTION_E140."); % Modify help description values as needed.

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E140| 
% C++ Signature: MODULE_DESCRIPTION_E140::MODULE_DESCRIPTION_E140(MODULE_DESCRIPTION_E140 const & input1)

MODULE_DESCRIPTION_E140Constructor1Definition = addConstructor(MODULE_DESCRIPTION_E140Definition, ...
    "MODULE_DESCRIPTION_E140::MODULE_DESCRIPTION_E140(MODULE_DESCRIPTION_E140 const & input1)", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E140 Constructor of C++ class MODULE_DESCRIPTION_E140."); % Modify help description values as needed.
defineArgument(MODULE_DESCRIPTION_E140Constructor1Definition, "input1", "clib.MyCppLib.MODULE_DESCRIPTION_E140", "input");
validate(MODULE_DESCRIPTION_E140Constructor1Definition);

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E140| 
% C++ Signature: MODULE_DESCRIPTION_E140::MODULE_DESCRIPTION_E140()

MODULE_DESCRIPTION_E140Constructor2Definition = addConstructor(MODULE_DESCRIPTION_E140Definition, ...
    "MODULE_DESCRIPTION_E140::MODULE_DESCRIPTION_E140()", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E140 Constructor of C++ class MODULE_DESCRIPTION_E140."); % Modify help description values as needed.
validate(MODULE_DESCRIPTION_E140Constructor2Definition);

%% C++ class public data member |Module| for C++ class |MODULE_DESCRIPTION_E140| 
% C++ Signature: MODULE_INFO_LUSBAPI MODULE_DESCRIPTION_E140::Module

addProperty(MODULE_DESCRIPTION_E140Definition, "Module", "clib.MyCppLib.MODULE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.MODULE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E140."); % Modify help description values as needed.

%% C++ class public data member |Interface| for C++ class |MODULE_DESCRIPTION_E140| 
% C++ Signature: INTERFACE_INFO_LUSBAPI MODULE_DESCRIPTION_E140::Interface

addProperty(MODULE_DESCRIPTION_E140Definition, "Interface", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E140."); % Modify help description values as needed.

%% C++ class public data member |Mcu| for C++ class |MODULE_DESCRIPTION_E140| 
% C++ Signature: MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI> MODULE_DESCRIPTION_E140::Mcu

addProperty(MODULE_DESCRIPTION_E140Definition, "Mcu", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_    Data member of C++ class MODULE_DESCRIPTION_E140."); % Modify help description values as needed.

%% C++ class public data member |Adc| for C++ class |MODULE_DESCRIPTION_E140| 
% C++ Signature: ADC_INFO_LUSBAPI MODULE_DESCRIPTION_E140::Adc

addProperty(MODULE_DESCRIPTION_E140Definition, "Adc", "clib.MyCppLib.ADC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.ADC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E140."); % Modify help description values as needed.

%% C++ class public data member |Dac| for C++ class |MODULE_DESCRIPTION_E140| 
% C++ Signature: DAC_INFO_LUSBAPI MODULE_DESCRIPTION_E140::Dac

addProperty(MODULE_DESCRIPTION_E140Definition, "Dac", "clib.MyCppLib.DAC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DAC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E140."); % Modify help description values as needed.

%% C++ class public data member |DigitalIo| for C++ class |MODULE_DESCRIPTION_E140| 
% C++ Signature: DIGITAL_IO_INFO_LUSBAPI MODULE_DESCRIPTION_E140::DigitalIo

addProperty(MODULE_DESCRIPTION_E140Definition, "DigitalIo", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E140."); % Modify help description values as needed.

%% C++ class |USER_FLASH_E140| with MATLAB name |clib.MyCppLib.USER_FLASH_E140| 
USER_FLASH_E140Definition = addClass(libDef, "USER_FLASH_E140", "MATLABName", "clib.MyCppLib.USER_FLASH_E140", ...
    "Description", "clib.MyCppLib.USER_FLASH_E140    Representation of C++ class USER_FLASH_E140."); % Modify help description values as needed.

%% C++ class constructor for C++ class |USER_FLASH_E140| 
% C++ Signature: USER_FLASH_E140::USER_FLASH_E140(USER_FLASH_E140 const & input1)

USER_FLASH_E140Constructor1Definition = addConstructor(USER_FLASH_E140Definition, ...
    "USER_FLASH_E140::USER_FLASH_E140(USER_FLASH_E140 const & input1)", ...
    "Description", "clib.MyCppLib.USER_FLASH_E140 Constructor of C++ class USER_FLASH_E140."); % Modify help description values as needed.
defineArgument(USER_FLASH_E140Constructor1Definition, "input1", "clib.MyCppLib.USER_FLASH_E140", "input");
validate(USER_FLASH_E140Constructor1Definition);

%% C++ class constructor for C++ class |USER_FLASH_E140| 
% C++ Signature: USER_FLASH_E140::USER_FLASH_E140()

USER_FLASH_E140Constructor2Definition = addConstructor(USER_FLASH_E140Definition, ...
    "USER_FLASH_E140::USER_FLASH_E140()", ...
    "Description", "clib.MyCppLib.USER_FLASH_E140 Constructor of C++ class USER_FLASH_E140."); % Modify help description values as needed.
validate(USER_FLASH_E140Constructor2Definition);

%% C++ class public data member |Buffer| for C++ class |USER_FLASH_E140| 
% C++ Signature: BYTE [512] USER_FLASH_E140::Buffer

addProperty(USER_FLASH_E140Definition, "Buffer", "clib.array.MyCppLib.UnsignedChar", [512], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class USER_FLASH_E140."); % Modify help description values as needed.

%% C++ class |ADC_PARS_E140| with MATLAB name |clib.MyCppLib.ADC_PARS_E140| 
ADC_PARS_E140Definition = addClass(libDef, "ADC_PARS_E140", "MATLABName", "clib.MyCppLib.ADC_PARS_E140", ...
    "Description", "clib.MyCppLib.ADC_PARS_E140    Representation of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class constructor for C++ class |ADC_PARS_E140| 
% C++ Signature: ADC_PARS_E140::ADC_PARS_E140(ADC_PARS_E140 const & input1)

ADC_PARS_E140Constructor1Definition = addConstructor(ADC_PARS_E140Definition, ...
    "ADC_PARS_E140::ADC_PARS_E140(ADC_PARS_E140 const & input1)", ...
    "Description", "clib.MyCppLib.ADC_PARS_E140 Constructor of C++ class ADC_PARS_E140."); % Modify help description values as needed.
defineArgument(ADC_PARS_E140Constructor1Definition, "input1", "clib.MyCppLib.ADC_PARS_E140", "input");
validate(ADC_PARS_E140Constructor1Definition);

%% C++ class constructor for C++ class |ADC_PARS_E140| 
% C++ Signature: ADC_PARS_E140::ADC_PARS_E140()

ADC_PARS_E140Constructor2Definition = addConstructor(ADC_PARS_E140Definition, ...
    "ADC_PARS_E140::ADC_PARS_E140()", ...
    "Description", "clib.MyCppLib.ADC_PARS_E140 Constructor of C++ class ADC_PARS_E140."); % Modify help description values as needed.
validate(ADC_PARS_E140Constructor2Definition);

%% C++ class public data member |ClkSource| for C++ class |ADC_PARS_E140| 
% C++ Signature: WORD ADC_PARS_E140::ClkSource

addProperty(ADC_PARS_E140Definition, "ClkSource", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |EnableClkOutput| for C++ class |ADC_PARS_E140| 
% C++ Signature: WORD ADC_PARS_E140::EnableClkOutput

addProperty(ADC_PARS_E140Definition, "EnableClkOutput", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |InputMode| for C++ class |ADC_PARS_E140| 
% C++ Signature: WORD ADC_PARS_E140::InputMode

addProperty(ADC_PARS_E140Definition, "InputMode", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdType| for C++ class |ADC_PARS_E140| 
% C++ Signature: WORD ADC_PARS_E140::SynchroAdType

addProperty(ADC_PARS_E140Definition, "SynchroAdType", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdMode| for C++ class |ADC_PARS_E140| 
% C++ Signature: WORD ADC_PARS_E140::SynchroAdMode

addProperty(ADC_PARS_E140Definition, "SynchroAdMode", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdChannel| for C++ class |ADC_PARS_E140| 
% C++ Signature: WORD ADC_PARS_E140::SynchroAdChannel

addProperty(ADC_PARS_E140Definition, "SynchroAdChannel", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdPorog| for C++ class |ADC_PARS_E140| 
% C++ Signature: SHORT ADC_PARS_E140::SynchroAdPorog

addProperty(ADC_PARS_E140Definition, "SynchroAdPorog", "int16", ...
    "Description", "int16    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |ChannelsQuantity| for C++ class |ADC_PARS_E140| 
% C++ Signature: WORD ADC_PARS_E140::ChannelsQuantity

addProperty(ADC_PARS_E140Definition, "ChannelsQuantity", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |ControlTable| for C++ class |ADC_PARS_E140| 
% C++ Signature: WORD [128] ADC_PARS_E140::ControlTable

addProperty(ADC_PARS_E140Definition, "ControlTable", "clib.array.MyCppLib.UnsignedShort", [128], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
    "Description", "clib.array.MyCppLib.UnsignedShort    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |AdcRate| for C++ class |ADC_PARS_E140| 
% C++ Signature: double ADC_PARS_E140::AdcRate

addProperty(ADC_PARS_E140Definition, "AdcRate", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |InterKadrDelay| for C++ class |ADC_PARS_E140| 
% C++ Signature: double ADC_PARS_E140::InterKadrDelay

addProperty(ADC_PARS_E140Definition, "InterKadrDelay", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |KadrRate| for C++ class |ADC_PARS_E140| 
% C++ Signature: double ADC_PARS_E140::KadrRate

addProperty(ADC_PARS_E140Definition, "KadrRate", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E140."); % Modify help description values as needed.

%% C++ class |DAC_PARS_E140| with MATLAB name |clib.MyCppLib.DAC_PARS_E140| 
DAC_PARS_E140Definition = addClass(libDef, "DAC_PARS_E140", "MATLABName", "clib.MyCppLib.DAC_PARS_E140", ...
    "Description", "clib.MyCppLib.DAC_PARS_E140    Representation of C++ class DAC_PARS_E140."); % Modify help description values as needed.

%% C++ class constructor for C++ class |DAC_PARS_E140| 
% C++ Signature: DAC_PARS_E140::DAC_PARS_E140(DAC_PARS_E140 const & input1)

DAC_PARS_E140Constructor1Definition = addConstructor(DAC_PARS_E140Definition, ...
    "DAC_PARS_E140::DAC_PARS_E140(DAC_PARS_E140 const & input1)", ...
    "Description", "clib.MyCppLib.DAC_PARS_E140 Constructor of C++ class DAC_PARS_E140."); % Modify help description values as needed.
defineArgument(DAC_PARS_E140Constructor1Definition, "input1", "clib.MyCppLib.DAC_PARS_E140", "input");
validate(DAC_PARS_E140Constructor1Definition);

%% C++ class constructor for C++ class |DAC_PARS_E140| 
% C++ Signature: DAC_PARS_E140::DAC_PARS_E140()

DAC_PARS_E140Constructor2Definition = addConstructor(DAC_PARS_E140Definition, ...
    "DAC_PARS_E140::DAC_PARS_E140()", ...
    "Description", "clib.MyCppLib.DAC_PARS_E140 Constructor of C++ class DAC_PARS_E140."); % Modify help description values as needed.
validate(DAC_PARS_E140Constructor2Definition);

%% C++ class public data member |SyncWithADC| for C++ class |DAC_PARS_E140| 
% C++ Signature: BYTE DAC_PARS_E140::SyncWithADC

addProperty(DAC_PARS_E140Definition, "SyncWithADC", "uint8", ...
    "Description", "uint8    Data member of C++ class DAC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |SetZeroOnStop| for C++ class |DAC_PARS_E140| 
% C++ Signature: BYTE DAC_PARS_E140::SetZeroOnStop

addProperty(DAC_PARS_E140Definition, "SetZeroOnStop", "uint8", ...
    "Description", "uint8    Data member of C++ class DAC_PARS_E140."); % Modify help description values as needed.

%% C++ class public data member |DacRate| for C++ class |DAC_PARS_E140| 
% C++ Signature: double DAC_PARS_E140::DacRate

addProperty(DAC_PARS_E140Definition, "DacRate", "double", ...
    "Description", "double    Data member of C++ class DAC_PARS_E140."); % Modify help description values as needed.

%% C++ class |ILE140| with MATLAB name |clib.MyCppLib.ILE140| 
ILE140Definition = addClass(libDef, "ILE140", "MATLABName", "clib.MyCppLib.ILE140", ...
    "Description", "clib.MyCppLib.ILE140    Representation of C++ class ILE140."); % Modify help description values as needed.

%% C++ class method |GET_ADC_PARS| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::GET_ADC_PARS(ADC_PARS_E140 * const AdcPars)

%GET_ADC_PARSDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::GET_ADC_PARS(ADC_PARS_E140 * const AdcPars)", ...
%    "MATLABName", "GET_ADC_PARS", ...
%    "Description", "GET_ADC_PARS Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(GET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E140", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E140", or "clib.array.MyCppLib.ADC_PARS_E140"
%defineOutput(GET_ADC_PARSDefinition, "RetVal", "int32");
%validate(GET_ADC_PARSDefinition);

%% C++ class method |SET_ADC_PARS| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::SET_ADC_PARS(ADC_PARS_E140 * const AdcPars)

%SET_ADC_PARSDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::SET_ADC_PARS(ADC_PARS_E140 * const AdcPars)", ...
%    "MATLABName", "SET_ADC_PARS", ...
%    "Description", "SET_ADC_PARS Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(SET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E140", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E140", or "clib.array.MyCppLib.ADC_PARS_E140"
%defineOutput(SET_ADC_PARSDefinition, "RetVal", "int32");
%validate(SET_ADC_PARSDefinition);

%% C++ class method |START_ADC| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::START_ADC()

START_ADCDefinition = addMethod(ILE140Definition, ...
    "BOOL ILE140::START_ADC()", ...
    "MATLABName", "START_ADC", ...
    "Description", "START_ADC Method of C++ class ILE140."); % Modify help description values as needed.
defineOutput(START_ADCDefinition, "RetVal", "int32");
validate(START_ADCDefinition);

%% C++ class method |STOP_ADC| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::STOP_ADC()

STOP_ADCDefinition = addMethod(ILE140Definition, ...
    "BOOL ILE140::STOP_ADC()", ...
    "MATLABName", "STOP_ADC", ...
    "Description", "STOP_ADC Method of C++ class ILE140."); % Modify help description values as needed.
defineOutput(STOP_ADCDefinition, "RetVal", "int32");
validate(STOP_ADCDefinition);

%% C++ class method |ADC_KADR| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::ADC_KADR(SHORT * const Data)

%ADC_KADRDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::ADC_KADR(SHORT * const Data)", ...
%    "MATLABName", "ADC_KADR", ...
%    "Description", "ADC_KADR Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(ADC_KADRDefinition, "Data", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineOutput(ADC_KADRDefinition, "RetVal", "int32");
%validate(ADC_KADRDefinition);

%% C++ class method |ADC_SAMPLE| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::ADC_SAMPLE(SHORT * const AdcData,WORD AdcChannel)

%ADC_SAMPLEDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::ADC_SAMPLE(SHORT * const AdcData,WORD AdcChannel)", ...
%    "MATLABName", "ADC_SAMPLE", ...
%    "Description", "ADC_SAMPLE Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(ADC_SAMPLEDefinition, "AdcData", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineArgument(ADC_SAMPLEDefinition, "AdcChannel", "uint16");
%defineOutput(ADC_SAMPLEDefinition, "RetVal", "int32");
%validate(ADC_SAMPLEDefinition);

%% C++ class method |ReadData| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::ReadData(IO_REQUEST_LUSBAPI * const ReadRequest)

%ReadDataDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::ReadData(IO_REQUEST_LUSBAPI * const ReadRequest)", ...
%    "MATLABName", "ReadData", ...
%    "Description", "ReadData Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(ReadDataDefinition, "ReadRequest", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
%defineOutput(ReadDataDefinition, "RetVal", "int32");
%validate(ReadDataDefinition);

%% C++ class method |GET_DAC_PARS| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::GET_DAC_PARS(DAC_PARS_E140 * const DacPars)

%GET_DAC_PARSDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::GET_DAC_PARS(DAC_PARS_E140 * const DacPars)", ...
%    "MATLABName", "GET_DAC_PARS", ...
%    "Description", "GET_DAC_PARS Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(GET_DAC_PARSDefinition, "DacPars", "clib.MyCppLib.DAC_PARS_E140", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.DAC_PARS_E140", or "clib.array.MyCppLib.DAC_PARS_E140"
%defineOutput(GET_DAC_PARSDefinition, "RetVal", "int32");
%validate(GET_DAC_PARSDefinition);

%% C++ class method |SET_DAC_PARS| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::SET_DAC_PARS(DAC_PARS_E140 * const DacPars)

%SET_DAC_PARSDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::SET_DAC_PARS(DAC_PARS_E140 * const DacPars)", ...
%    "MATLABName", "SET_DAC_PARS", ...
%    "Description", "SET_DAC_PARS Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(SET_DAC_PARSDefinition, "DacPars", "clib.MyCppLib.DAC_PARS_E140", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.DAC_PARS_E140", or "clib.array.MyCppLib.DAC_PARS_E140"
%defineOutput(SET_DAC_PARSDefinition, "RetVal", "int32");
%validate(SET_DAC_PARSDefinition);

%% C++ class method |START_DAC| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::START_DAC()

START_DACDefinition = addMethod(ILE140Definition, ...
    "BOOL ILE140::START_DAC()", ...
    "MATLABName", "START_DAC", ...
    "Description", "START_DAC Method of C++ class ILE140."); % Modify help description values as needed.
defineOutput(START_DACDefinition, "RetVal", "int32");
validate(START_DACDefinition);

%% C++ class method |STOP_DAC| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::STOP_DAC()

STOP_DACDefinition = addMethod(ILE140Definition, ...
    "BOOL ILE140::STOP_DAC()", ...
    "MATLABName", "STOP_DAC", ...
    "Description", "STOP_DAC Method of C++ class ILE140."); % Modify help description values as needed.
defineOutput(STOP_DACDefinition, "RetVal", "int32");
validate(STOP_DACDefinition);

%% C++ class method |WriteData| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::WriteData(IO_REQUEST_LUSBAPI * const WriteRequest)

%WriteDataDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::WriteData(IO_REQUEST_LUSBAPI * const WriteRequest)", ...
%    "MATLABName", "WriteData", ...
%    "Description", "WriteData Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(WriteDataDefinition, "WriteRequest", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
%defineOutput(WriteDataDefinition, "RetVal", "int32");
%validate(WriteDataDefinition);

%% C++ class method |DAC_SAMPLE| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::DAC_SAMPLE(SHORT * const DacData,WORD DacChannel)

%DAC_SAMPLEDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::DAC_SAMPLE(SHORT * const DacData,WORD DacChannel)", ...
%    "MATLABName", "DAC_SAMPLE", ...
%    "Description", "DAC_SAMPLE Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(DAC_SAMPLEDefinition, "DacData", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineArgument(DAC_SAMPLEDefinition, "DacChannel", "uint16");
%defineOutput(DAC_SAMPLEDefinition, "RetVal", "int32");
%validate(DAC_SAMPLEDefinition);

%% C++ class method |DAC_SAMPLES| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::DAC_SAMPLES(SHORT * const DacData1,SHORT * const DacData2)

%DAC_SAMPLESDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::DAC_SAMPLES(SHORT * const DacData1,SHORT * const DacData2)", ...
%    "MATLABName", "DAC_SAMPLES", ...
%    "Description", "DAC_SAMPLES Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(DAC_SAMPLESDefinition, "DacData1", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineArgument(DAC_SAMPLESDefinition, "DacData2", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineOutput(DAC_SAMPLESDefinition, "RetVal", "int32");
%validate(DAC_SAMPLESDefinition);

%% C++ class method |ENABLE_TTL_OUT| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::ENABLE_TTL_OUT(BOOL EnableTtlOut)

ENABLE_TTL_OUTDefinition = addMethod(ILE140Definition, ...
    "BOOL ILE140::ENABLE_TTL_OUT(BOOL EnableTtlOut)", ...
    "MATLABName", "ENABLE_TTL_OUT", ...
    "Description", "ENABLE_TTL_OUT Method of C++ class ILE140."); % Modify help description values as needed.
defineArgument(ENABLE_TTL_OUTDefinition, "EnableTtlOut", "int32");
defineOutput(ENABLE_TTL_OUTDefinition, "RetVal", "int32");
validate(ENABLE_TTL_OUTDefinition);

%% C++ class method |TTL_IN| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::TTL_IN(WORD * const TtlIn)

%TTL_INDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::TTL_IN(WORD * const TtlIn)", ...
%    "MATLABName", "TTL_IN", ...
%    "Description", "TTL_IN Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(TTL_INDefinition, "TtlIn", "clib.array.MyCppLib.UnsignedShort", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
%defineOutput(TTL_INDefinition, "RetVal", "int32");
%validate(TTL_INDefinition);

%% C++ class method |TTL_OUT| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::TTL_OUT(WORD TtlOut)

TTL_OUTDefinition = addMethod(ILE140Definition, ...
    "BOOL ILE140::TTL_OUT(WORD TtlOut)", ...
    "MATLABName", "TTL_OUT", ...
    "Description", "TTL_OUT Method of C++ class ILE140."); % Modify help description values as needed.
defineArgument(TTL_OUTDefinition, "TtlOut", "uint16");
defineOutput(TTL_OUTDefinition, "RetVal", "int32");
validate(TTL_OUTDefinition);

%% C++ class method |ENABLE_FLASH_WRITE| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::ENABLE_FLASH_WRITE(BOOL IsUserFlashWriteEnabled)

ENABLE_FLASH_WRITEDefinition = addMethod(ILE140Definition, ...
    "BOOL ILE140::ENABLE_FLASH_WRITE(BOOL IsUserFlashWriteEnabled)", ...
    "MATLABName", "ENABLE_FLASH_WRITE", ...
    "Description", "ENABLE_FLASH_WRITE Method of C++ class ILE140."); % Modify help description values as needed.
defineArgument(ENABLE_FLASH_WRITEDefinition, "IsUserFlashWriteEnabled", "int32");
defineOutput(ENABLE_FLASH_WRITEDefinition, "RetVal", "int32");
validate(ENABLE_FLASH_WRITEDefinition);

%% C++ class method |READ_FLASH_ARRAY| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::READ_FLASH_ARRAY(USER_FLASH_E140 * const UserFlash)

%READ_FLASH_ARRAYDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::READ_FLASH_ARRAY(USER_FLASH_E140 * const UserFlash)", ...
%    "MATLABName", "READ_FLASH_ARRAY", ...
%    "Description", "READ_FLASH_ARRAY Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(READ_FLASH_ARRAYDefinition, "UserFlash", "clib.MyCppLib.USER_FLASH_E140", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.USER_FLASH_E140", or "clib.array.MyCppLib.USER_FLASH_E140"
%defineOutput(READ_FLASH_ARRAYDefinition, "RetVal", "int32");
%validate(READ_FLASH_ARRAYDefinition);

%% C++ class method |WRITE_FLASH_ARRAY| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::WRITE_FLASH_ARRAY(USER_FLASH_E140 * const UserFlash)

%WRITE_FLASH_ARRAYDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::WRITE_FLASH_ARRAY(USER_FLASH_E140 * const UserFlash)", ...
%    "MATLABName", "WRITE_FLASH_ARRAY", ...
%    "Description", "WRITE_FLASH_ARRAY Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(WRITE_FLASH_ARRAYDefinition, "UserFlash", "clib.MyCppLib.USER_FLASH_E140", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.USER_FLASH_E140", or "clib.array.MyCppLib.USER_FLASH_E140"
%defineOutput(WRITE_FLASH_ARRAYDefinition, "RetVal", "int32");
%validate(WRITE_FLASH_ARRAYDefinition);

%% C++ class method |GET_MODULE_DESCRIPTION| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E140 * const ModuleDescription)

%GET_MODULE_DESCRIPTIONDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E140 * const ModuleDescription)", ...
%    "MATLABName", "GET_MODULE_DESCRIPTION", ...
%    "Description", "GET_MODULE_DESCRIPTION Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(GET_MODULE_DESCRIPTIONDefinition, "ModuleDescription", "clib.MyCppLib.MODULE_DESCRIPTION_E140", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E140", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E140"
%defineOutput(GET_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
%validate(GET_MODULE_DESCRIPTIONDefinition);

%% C++ class method |SAVE_MODULE_DESCRIPTION| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E140 * const ModuleDescription)

%SAVE_MODULE_DESCRIPTIONDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E140 * const ModuleDescription)", ...
%    "MATLABName", "SAVE_MODULE_DESCRIPTION", ...
%    "Description", "SAVE_MODULE_DESCRIPTION Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(SAVE_MODULE_DESCRIPTIONDefinition, "ModuleDescription", "clib.MyCppLib.MODULE_DESCRIPTION_E140", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E140", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E140"
%defineOutput(SAVE_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
%validate(SAVE_MODULE_DESCRIPTIONDefinition);

%% C++ class method |GetArray| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::GetArray(BYTE * const Buffer,WORD Size,WORD Address)

%GetArrayDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::GetArray(BYTE * const Buffer,WORD Size,WORD Address)", ...
%    "MATLABName", "GetArray", ...
%    "Description", "GetArray Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(GetArrayDefinition, "Buffer", "clib.array.MyCppLib.UnsignedChar", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
%defineArgument(GetArrayDefinition, "Size", "uint16");
%defineArgument(GetArrayDefinition, "Address", "uint16");
%defineOutput(GetArrayDefinition, "RetVal", "int32");
%validate(GetArrayDefinition);

%% C++ class method |PutArray| for C++ class |ILE140| 
% C++ Signature: BOOL ILE140::PutArray(BYTE * const Buffer,WORD Size,WORD Address)

%PutArrayDefinition = addMethod(ILE140Definition, ...
%    "BOOL ILE140::PutArray(BYTE * const Buffer,WORD Size,WORD Address)", ...
%    "MATLABName", "PutArray", ...
%    "Description", "PutArray Method of C++ class ILE140."); % Modify help description values as needed.
%defineArgument(PutArrayDefinition, "Buffer", "clib.array.MyCppLib.UnsignedChar", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
%defineArgument(PutArrayDefinition, "Size", "uint16");
%defineArgument(PutArrayDefinition, "Address", "uint16");
%defineOutput(PutArrayDefinition, "RetVal", "int32");
%validate(PutArrayDefinition);

%% C++ class |MODULE_DESCRIPTION_E154| with MATLAB name |clib.MyCppLib.MODULE_DESCRIPTION_E154| 
MODULE_DESCRIPTION_E154Definition = addClass(libDef, "MODULE_DESCRIPTION_E154", "MATLABName", "clib.MyCppLib.MODULE_DESCRIPTION_E154", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E154    Representation of C++ class MODULE_DESCRIPTION_E154."); % Modify help description values as needed.

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E154| 
% C++ Signature: MODULE_DESCRIPTION_E154::MODULE_DESCRIPTION_E154(MODULE_DESCRIPTION_E154 const & input1)

MODULE_DESCRIPTION_E154Constructor1Definition = addConstructor(MODULE_DESCRIPTION_E154Definition, ...
    "MODULE_DESCRIPTION_E154::MODULE_DESCRIPTION_E154(MODULE_DESCRIPTION_E154 const & input1)", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E154 Constructor of C++ class MODULE_DESCRIPTION_E154."); % Modify help description values as needed.
defineArgument(MODULE_DESCRIPTION_E154Constructor1Definition, "input1", "clib.MyCppLib.MODULE_DESCRIPTION_E154", "input");
validate(MODULE_DESCRIPTION_E154Constructor1Definition);

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E154| 
% C++ Signature: MODULE_DESCRIPTION_E154::MODULE_DESCRIPTION_E154()

MODULE_DESCRIPTION_E154Constructor2Definition = addConstructor(MODULE_DESCRIPTION_E154Definition, ...
    "MODULE_DESCRIPTION_E154::MODULE_DESCRIPTION_E154()", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E154 Constructor of C++ class MODULE_DESCRIPTION_E154."); % Modify help description values as needed.
validate(MODULE_DESCRIPTION_E154Constructor2Definition);

%% C++ class public data member |Module| for C++ class |MODULE_DESCRIPTION_E154| 
% C++ Signature: MODULE_INFO_LUSBAPI MODULE_DESCRIPTION_E154::Module

addProperty(MODULE_DESCRIPTION_E154Definition, "Module", "clib.MyCppLib.MODULE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.MODULE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E154."); % Modify help description values as needed.

%% C++ class public data member |Interface| for C++ class |MODULE_DESCRIPTION_E154| 
% C++ Signature: INTERFACE_INFO_LUSBAPI MODULE_DESCRIPTION_E154::Interface

addProperty(MODULE_DESCRIPTION_E154Definition, "Interface", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E154."); % Modify help description values as needed.

%% C++ class public data member |Mcu| for C++ class |MODULE_DESCRIPTION_E154| 
% C++ Signature: MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI> MODULE_DESCRIPTION_E154::Mcu

addProperty(MODULE_DESCRIPTION_E154Definition, "Mcu", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_    Data member of C++ class MODULE_DESCRIPTION_E154."); % Modify help description values as needed.

%% C++ class public data member |Adc| for C++ class |MODULE_DESCRIPTION_E154| 
% C++ Signature: ADC_INFO_LUSBAPI MODULE_DESCRIPTION_E154::Adc

addProperty(MODULE_DESCRIPTION_E154Definition, "Adc", "clib.MyCppLib.ADC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.ADC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E154."); % Modify help description values as needed.

%% C++ class public data member |Dac| for C++ class |MODULE_DESCRIPTION_E154| 
% C++ Signature: DAC_INFO_LUSBAPI MODULE_DESCRIPTION_E154::Dac

addProperty(MODULE_DESCRIPTION_E154Definition, "Dac", "clib.MyCppLib.DAC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DAC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E154."); % Modify help description values as needed.

%% C++ class public data member |DigitalIo| for C++ class |MODULE_DESCRIPTION_E154| 
% C++ Signature: DIGITAL_IO_INFO_LUSBAPI MODULE_DESCRIPTION_E154::DigitalIo

addProperty(MODULE_DESCRIPTION_E154Definition, "DigitalIo", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E154."); % Modify help description values as needed.

%% C++ class |ADC_PARS_E154| with MATLAB name |clib.MyCppLib.ADC_PARS_E154| 
ADC_PARS_E154Definition = addClass(libDef, "ADC_PARS_E154", "MATLABName", "clib.MyCppLib.ADC_PARS_E154", ...
    "Description", "clib.MyCppLib.ADC_PARS_E154    Representation of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class constructor for C++ class |ADC_PARS_E154| 
% C++ Signature: ADC_PARS_E154::ADC_PARS_E154(ADC_PARS_E154 const & input1)

ADC_PARS_E154Constructor1Definition = addConstructor(ADC_PARS_E154Definition, ...
    "ADC_PARS_E154::ADC_PARS_E154(ADC_PARS_E154 const & input1)", ...
    "Description", "clib.MyCppLib.ADC_PARS_E154 Constructor of C++ class ADC_PARS_E154."); % Modify help description values as needed.
defineArgument(ADC_PARS_E154Constructor1Definition, "input1", "clib.MyCppLib.ADC_PARS_E154", "input");
validate(ADC_PARS_E154Constructor1Definition);

%% C++ class constructor for C++ class |ADC_PARS_E154| 
% C++ Signature: ADC_PARS_E154::ADC_PARS_E154()

ADC_PARS_E154Constructor2Definition = addConstructor(ADC_PARS_E154Definition, ...
    "ADC_PARS_E154::ADC_PARS_E154()", ...
    "Description", "clib.MyCppLib.ADC_PARS_E154 Constructor of C++ class ADC_PARS_E154."); % Modify help description values as needed.
validate(ADC_PARS_E154Constructor2Definition);

%% C++ class public data member |ClkSource| for C++ class |ADC_PARS_E154| 
% C++ Signature: WORD ADC_PARS_E154::ClkSource

addProperty(ADC_PARS_E154Definition, "ClkSource", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |EnableClkOutput| for C++ class |ADC_PARS_E154| 
% C++ Signature: WORD ADC_PARS_E154::EnableClkOutput

addProperty(ADC_PARS_E154Definition, "EnableClkOutput", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |InputMode| for C++ class |ADC_PARS_E154| 
% C++ Signature: WORD ADC_PARS_E154::InputMode

addProperty(ADC_PARS_E154Definition, "InputMode", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdType| for C++ class |ADC_PARS_E154| 
% C++ Signature: WORD ADC_PARS_E154::SynchroAdType

addProperty(ADC_PARS_E154Definition, "SynchroAdType", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdMode| for C++ class |ADC_PARS_E154| 
% C++ Signature: WORD ADC_PARS_E154::SynchroAdMode

addProperty(ADC_PARS_E154Definition, "SynchroAdMode", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdChannel| for C++ class |ADC_PARS_E154| 
% C++ Signature: WORD ADC_PARS_E154::SynchroAdChannel

addProperty(ADC_PARS_E154Definition, "SynchroAdChannel", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdPorog| for C++ class |ADC_PARS_E154| 
% C++ Signature: SHORT ADC_PARS_E154::SynchroAdPorog

addProperty(ADC_PARS_E154Definition, "SynchroAdPorog", "int16", ...
    "Description", "int16    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |ChannelsQuantity| for C++ class |ADC_PARS_E154| 
% C++ Signature: WORD ADC_PARS_E154::ChannelsQuantity

addProperty(ADC_PARS_E154Definition, "ChannelsQuantity", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |ControlTable| for C++ class |ADC_PARS_E154| 
% C++ Signature: WORD [16] ADC_PARS_E154::ControlTable

addProperty(ADC_PARS_E154Definition, "ControlTable", "clib.array.MyCppLib.UnsignedShort", [16], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
    "Description", "clib.array.MyCppLib.UnsignedShort    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |AdcRate| for C++ class |ADC_PARS_E154| 
% C++ Signature: double ADC_PARS_E154::AdcRate

addProperty(ADC_PARS_E154Definition, "AdcRate", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |InterKadrDelay| for C++ class |ADC_PARS_E154| 
% C++ Signature: double ADC_PARS_E154::InterKadrDelay

addProperty(ADC_PARS_E154Definition, "InterKadrDelay", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class public data member |KadrRate| for C++ class |ADC_PARS_E154| 
% C++ Signature: double ADC_PARS_E154::KadrRate

addProperty(ADC_PARS_E154Definition, "KadrRate", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E154."); % Modify help description values as needed.

%% C++ class |ILE154| with MATLAB name |clib.MyCppLib.ILE154| 
ILE154Definition = addClass(libDef, "ILE154", "MATLABName", "clib.MyCppLib.ILE154", ...
    "Description", "clib.MyCppLib.ILE154    Representation of C++ class ILE154."); % Modify help description values as needed.

%% C++ class method |GET_ADC_PARS| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::GET_ADC_PARS(ADC_PARS_E154 * const AdcPars)

%GET_ADC_PARSDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::GET_ADC_PARS(ADC_PARS_E154 * const AdcPars)", ...
%    "MATLABName", "GET_ADC_PARS", ...
%    "Description", "GET_ADC_PARS Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(GET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E154", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E154", or "clib.array.MyCppLib.ADC_PARS_E154"
%defineOutput(GET_ADC_PARSDefinition, "RetVal", "int32");
%validate(GET_ADC_PARSDefinition);

%% C++ class method |SET_ADC_PARS| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::SET_ADC_PARS(ADC_PARS_E154 * const AdcPars)

%SET_ADC_PARSDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::SET_ADC_PARS(ADC_PARS_E154 * const AdcPars)", ...
%    "MATLABName", "SET_ADC_PARS", ...
%    "Description", "SET_ADC_PARS Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(SET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E154", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E154", or "clib.array.MyCppLib.ADC_PARS_E154"
%defineOutput(SET_ADC_PARSDefinition, "RetVal", "int32");
%validate(SET_ADC_PARSDefinition);

%% C++ class method |START_ADC| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::START_ADC()

START_ADCDefinition = addMethod(ILE154Definition, ...
    "BOOL ILE154::START_ADC()", ...
    "MATLABName", "START_ADC", ...
    "Description", "START_ADC Method of C++ class ILE154."); % Modify help description values as needed.
defineOutput(START_ADCDefinition, "RetVal", "int32");
validate(START_ADCDefinition);

%% C++ class method |STOP_ADC| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::STOP_ADC()

STOP_ADCDefinition = addMethod(ILE154Definition, ...
    "BOOL ILE154::STOP_ADC()", ...
    "MATLABName", "STOP_ADC", ...
    "Description", "STOP_ADC Method of C++ class ILE154."); % Modify help description values as needed.
defineOutput(STOP_ADCDefinition, "RetVal", "int32");
validate(STOP_ADCDefinition);

%% C++ class method |ADC_KADR| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::ADC_KADR(SHORT * const Data)

%ADC_KADRDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::ADC_KADR(SHORT * const Data)", ...
%    "MATLABName", "ADC_KADR", ...
%    "Description", "ADC_KADR Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(ADC_KADRDefinition, "Data", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineOutput(ADC_KADRDefinition, "RetVal", "int32");
%validate(ADC_KADRDefinition);

%% C++ class method |ADC_SAMPLE| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::ADC_SAMPLE(SHORT * const AdcData,WORD AdcChannel)

%ADC_SAMPLEDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::ADC_SAMPLE(SHORT * const AdcData,WORD AdcChannel)", ...
%    "MATLABName", "ADC_SAMPLE", ...
%    "Description", "ADC_SAMPLE Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(ADC_SAMPLEDefinition, "AdcData", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineArgument(ADC_SAMPLEDefinition, "AdcChannel", "uint16");
%defineOutput(ADC_SAMPLEDefinition, "RetVal", "int32");
%validate(ADC_SAMPLEDefinition);

%% C++ class method |ReadData| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::ReadData(IO_REQUEST_LUSBAPI * const ReadRequest)

%ReadDataDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::ReadData(IO_REQUEST_LUSBAPI * const ReadRequest)", ...
%    "MATLABName", "ReadData", ...
%    "Description", "ReadData Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(ReadDataDefinition, "ReadRequest", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
%defineOutput(ReadDataDefinition, "RetVal", "int32");
%validate(ReadDataDefinition);

%% C++ class method |ProcessArray| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::ProcessArray(SHORT * src,double * dest,DWORD size,BOOL calibr,BOOL volt)

%ProcessArrayDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::ProcessArray(SHORT * src,double * dest,DWORD size,BOOL calibr,BOOL volt)", ...
%    "MATLABName", "ProcessArray", ...
%    "Description", "ProcessArray Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(ProcessArrayDefinition, "src", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineArgument(ProcessArrayDefinition, "dest", "clib.array.MyCppLib.Double", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
%defineArgument(ProcessArrayDefinition, "size", "uint32");
%defineArgument(ProcessArrayDefinition, "calibr", "int32");
%defineArgument(ProcessArrayDefinition, "volt", "int32");
%defineOutput(ProcessArrayDefinition, "RetVal", "int32");
%validate(ProcessArrayDefinition);

%% C++ class method |ProcessOnePoint| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::ProcessOnePoint(SHORT src,double * dest,DWORD channel,BOOL calibr,BOOL volt)

%ProcessOnePointDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::ProcessOnePoint(SHORT src,double * dest,DWORD channel,BOOL calibr,BOOL volt)", ...
%    "MATLABName", "ProcessOnePoint", ...
%    "Description", "ProcessOnePoint Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(ProcessOnePointDefinition, "src", "int16");
%defineArgument(ProcessOnePointDefinition, "dest", "clib.array.MyCppLib.Double", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
%defineArgument(ProcessOnePointDefinition, "channel", "uint32");
%defineArgument(ProcessOnePointDefinition, "calibr", "int32");
%defineArgument(ProcessOnePointDefinition, "volt", "int32");
%defineOutput(ProcessOnePointDefinition, "RetVal", "int32");
%validate(ProcessOnePointDefinition);

%% C++ class method |FIFO_STATUS| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::FIFO_STATUS(DWORD * FifoOverflowFlag,double * FifoMaxPercentLoad,DWORD * FifoSize,DWORD * MaxFifoBytesUsed)

%FIFO_STATUSDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::FIFO_STATUS(DWORD * FifoOverflowFlag,double * FifoMaxPercentLoad,DWORD * FifoSize,DWORD * MaxFifoBytesUsed)", ...
%    "MATLABName", "FIFO_STATUS", ...
%    "Description", "FIFO_STATUS Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(FIFO_STATUSDefinition, "FifoOverflowFlag", "clib.array.MyCppLib.UnsignedLong", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedLong", or "uint32"
%defineArgument(FIFO_STATUSDefinition, "FifoMaxPercentLoad", "clib.array.MyCppLib.Double", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
%defineArgument(FIFO_STATUSDefinition, "FifoSize", "clib.array.MyCppLib.UnsignedLong", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedLong", or "uint32"
%defineArgument(FIFO_STATUSDefinition, "MaxFifoBytesUsed", "clib.array.MyCppLib.UnsignedLong", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedLong", or "uint32"
%defineOutput(FIFO_STATUSDefinition, "RetVal", "int32");
%validate(FIFO_STATUSDefinition);

%% C++ class method |DAC_SAMPLE| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::DAC_SAMPLE(SHORT * const DacData,WORD DacChannel)

%DAC_SAMPLEDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::DAC_SAMPLE(SHORT * const DacData,WORD DacChannel)", ...
%    "MATLABName", "DAC_SAMPLE", ...
%    "Description", "DAC_SAMPLE Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(DAC_SAMPLEDefinition, "DacData", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineArgument(DAC_SAMPLEDefinition, "DacChannel", "uint16");
%defineOutput(DAC_SAMPLEDefinition, "RetVal", "int32");
%validate(DAC_SAMPLEDefinition);

%% C++ class method |DAC_SAMPLE_VOLT| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::DAC_SAMPLE_VOLT(double const DacData,BOOL calibr)

DAC_SAMPLE_VOLTDefinition = addMethod(ILE154Definition, ...
    "BOOL ILE154::DAC_SAMPLE_VOLT(double const DacData,BOOL calibr)", ...
    "MATLABName", "DAC_SAMPLE_VOLT", ...
    "Description", "DAC_SAMPLE_VOLT Method of C++ class ILE154."); % Modify help description values as needed.
defineArgument(DAC_SAMPLE_VOLTDefinition, "DacData", "double");
defineArgument(DAC_SAMPLE_VOLTDefinition, "calibr", "int32");
defineOutput(DAC_SAMPLE_VOLTDefinition, "RetVal", "int32");
validate(DAC_SAMPLE_VOLTDefinition);

%% C++ class method |ENABLE_TTL_OUT| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::ENABLE_TTL_OUT(BOOL EnableTtlOut)

ENABLE_TTL_OUTDefinition = addMethod(ILE154Definition, ...
    "BOOL ILE154::ENABLE_TTL_OUT(BOOL EnableTtlOut)", ...
    "MATLABName", "ENABLE_TTL_OUT", ...
    "Description", "ENABLE_TTL_OUT Method of C++ class ILE154."); % Modify help description values as needed.
defineArgument(ENABLE_TTL_OUTDefinition, "EnableTtlOut", "int32");
defineOutput(ENABLE_TTL_OUTDefinition, "RetVal", "int32");
validate(ENABLE_TTL_OUTDefinition);

%% C++ class method |TTL_IN| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::TTL_IN(WORD * const TtlIn)

%TTL_INDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::TTL_IN(WORD * const TtlIn)", ...
%    "MATLABName", "TTL_IN", ...
%    "Description", "TTL_IN Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(TTL_INDefinition, "TtlIn", "clib.array.MyCppLib.UnsignedShort", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
%defineOutput(TTL_INDefinition, "RetVal", "int32");
%validate(TTL_INDefinition);

%% C++ class method |TTL_OUT| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::TTL_OUT(WORD TtlOut)

TTL_OUTDefinition = addMethod(ILE154Definition, ...
    "BOOL ILE154::TTL_OUT(WORD TtlOut)", ...
    "MATLABName", "TTL_OUT", ...
    "Description", "TTL_OUT Method of C++ class ILE154."); % Modify help description values as needed.
defineArgument(TTL_OUTDefinition, "TtlOut", "uint16");
defineOutput(TTL_OUTDefinition, "RetVal", "int32");
validate(TTL_OUTDefinition);

%% C++ class method |ENABLE_FLASH_WRITE| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::ENABLE_FLASH_WRITE(BOOL IsUserFlashWriteEnabled)

ENABLE_FLASH_WRITEDefinition = addMethod(ILE154Definition, ...
    "BOOL ILE154::ENABLE_FLASH_WRITE(BOOL IsUserFlashWriteEnabled)", ...
    "MATLABName", "ENABLE_FLASH_WRITE", ...
    "Description", "ENABLE_FLASH_WRITE Method of C++ class ILE154."); % Modify help description values as needed.
defineArgument(ENABLE_FLASH_WRITEDefinition, "IsUserFlashWriteEnabled", "int32");
defineOutput(ENABLE_FLASH_WRITEDefinition, "RetVal", "int32");
validate(ENABLE_FLASH_WRITEDefinition);

%% C++ class method |READ_FLASH_ARRAY| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::READ_FLASH_ARRAY(BYTE * const UserFlash)

%READ_FLASH_ARRAYDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::READ_FLASH_ARRAY(BYTE * const UserFlash)", ...
%    "MATLABName", "READ_FLASH_ARRAY", ...
%    "Description", "READ_FLASH_ARRAY Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(READ_FLASH_ARRAYDefinition, "UserFlash", "clib.array.MyCppLib.UnsignedChar", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
%defineOutput(READ_FLASH_ARRAYDefinition, "RetVal", "int32");
%validate(READ_FLASH_ARRAYDefinition);

%% C++ class method |WRITE_FLASH_ARRAY| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::WRITE_FLASH_ARRAY(BYTE * const UserFlash)

%WRITE_FLASH_ARRAYDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::WRITE_FLASH_ARRAY(BYTE * const UserFlash)", ...
%    "MATLABName", "WRITE_FLASH_ARRAY", ...
%    "Description", "WRITE_FLASH_ARRAY Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(WRITE_FLASH_ARRAYDefinition, "UserFlash", "clib.array.MyCppLib.UnsignedChar", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
%defineOutput(WRITE_FLASH_ARRAYDefinition, "RetVal", "int32");
%validate(WRITE_FLASH_ARRAYDefinition);

%% C++ class method |GET_MODULE_DESCRIPTION| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E154 * const ModuleDescription)

%GET_MODULE_DESCRIPTIONDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E154 * const ModuleDescription)", ...
%    "MATLABName", "GET_MODULE_DESCRIPTION", ...
%    "Description", "GET_MODULE_DESCRIPTION Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(GET_MODULE_DESCRIPTIONDefinition, "ModuleDescription", "clib.MyCppLib.MODULE_DESCRIPTION_E154", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E154", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E154"
%defineOutput(GET_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
%validate(GET_MODULE_DESCRIPTIONDefinition);

%% C++ class method |SAVE_MODULE_DESCRIPTION| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E154 * const ModuleDescription)

%SAVE_MODULE_DESCRIPTIONDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E154 * const ModuleDescription)", ...
%    "MATLABName", "SAVE_MODULE_DESCRIPTION", ...
%    "Description", "SAVE_MODULE_DESCRIPTION Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(SAVE_MODULE_DESCRIPTIONDefinition, "ModuleDescription", "clib.MyCppLib.MODULE_DESCRIPTION_E154", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E154", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E154"
%defineOutput(SAVE_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
%validate(SAVE_MODULE_DESCRIPTIONDefinition);

%% C++ class method |GetArray| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::GetArray(BYTE * const Buffer,WORD Size,WORD Address)

%GetArrayDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::GetArray(BYTE * const Buffer,WORD Size,WORD Address)", ...
%    "MATLABName", "GetArray", ...
%    "Description", "GetArray Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(GetArrayDefinition, "Buffer", "clib.array.MyCppLib.UnsignedChar", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
%defineArgument(GetArrayDefinition, "Size", "uint16");
%defineArgument(GetArrayDefinition, "Address", "uint16");
%defineOutput(GetArrayDefinition, "RetVal", "int32");
%validate(GetArrayDefinition);

%% C++ class method |PutArray| for C++ class |ILE154| 
% C++ Signature: BOOL ILE154::PutArray(BYTE * const Buffer,WORD Size,WORD Address)

%PutArrayDefinition = addMethod(ILE154Definition, ...
%    "BOOL ILE154::PutArray(BYTE * const Buffer,WORD Size,WORD Address)", ...
%    "MATLABName", "PutArray", ...
%    "Description", "PutArray Method of C++ class ILE154."); % Modify help description values as needed.
%defineArgument(PutArrayDefinition, "Buffer", "clib.array.MyCppLib.UnsignedChar", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
%defineArgument(PutArrayDefinition, "Size", "uint16");
%defineArgument(PutArrayDefinition, "Address", "uint16");
%defineOutput(PutArrayDefinition, "RetVal", "int32");
%validate(PutArrayDefinition);

%% C++ class |MODULE_DESCRIPTION_E440| with MATLAB name |clib.MyCppLib.MODULE_DESCRIPTION_E440| 
MODULE_DESCRIPTION_E440Definition = addClass(libDef, "MODULE_DESCRIPTION_E440", "MATLABName", "clib.MyCppLib.MODULE_DESCRIPTION_E440", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E440    Representation of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E440| 
% C++ Signature: MODULE_DESCRIPTION_E440::MODULE_DESCRIPTION_E440(MODULE_DESCRIPTION_E440 const & input1)

MODULE_DESCRIPTION_E440Constructor1Definition = addConstructor(MODULE_DESCRIPTION_E440Definition, ...
    "MODULE_DESCRIPTION_E440::MODULE_DESCRIPTION_E440(MODULE_DESCRIPTION_E440 const & input1)", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E440 Constructor of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.
defineArgument(MODULE_DESCRIPTION_E440Constructor1Definition, "input1", "clib.MyCppLib.MODULE_DESCRIPTION_E440", "input");
validate(MODULE_DESCRIPTION_E440Constructor1Definition);

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E440| 
% C++ Signature: MODULE_DESCRIPTION_E440::MODULE_DESCRIPTION_E440()

MODULE_DESCRIPTION_E440Constructor2Definition = addConstructor(MODULE_DESCRIPTION_E440Definition, ...
    "MODULE_DESCRIPTION_E440::MODULE_DESCRIPTION_E440()", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E440 Constructor of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.
validate(MODULE_DESCRIPTION_E440Constructor2Definition);

%% C++ class public data member |Module| for C++ class |MODULE_DESCRIPTION_E440| 
% C++ Signature: MODULE_INFO_LUSBAPI MODULE_DESCRIPTION_E440::Module

addProperty(MODULE_DESCRIPTION_E440Definition, "Module", "clib.MyCppLib.MODULE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.MODULE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.

%% C++ class public data member |Interface| for C++ class |MODULE_DESCRIPTION_E440| 
% C++ Signature: INTERFACE_INFO_LUSBAPI MODULE_DESCRIPTION_E440::Interface

addProperty(MODULE_DESCRIPTION_E440Definition, "Interface", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.

%% C++ class public data member |Mcu| for C++ class |MODULE_DESCRIPTION_E440| 
% C++ Signature: MCU_INFO_LUSBAPI<VERSION_INFO_LUSBAPI> MODULE_DESCRIPTION_E440::Mcu

addProperty(MODULE_DESCRIPTION_E440Definition, "Mcu", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_VERSION_INFO_LUSBAPI_    Data member of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.

%% C++ class public data member |Dsp| for C++ class |MODULE_DESCRIPTION_E440| 
% C++ Signature: DSP_INFO_LUSBAPI MODULE_DESCRIPTION_E440::Dsp

addProperty(MODULE_DESCRIPTION_E440Definition, "Dsp", "clib.MyCppLib.DSP_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DSP_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.

%% C++ class public data member |Adc| for C++ class |MODULE_DESCRIPTION_E440| 
% C++ Signature: ADC_INFO_LUSBAPI MODULE_DESCRIPTION_E440::Adc

addProperty(MODULE_DESCRIPTION_E440Definition, "Adc", "clib.MyCppLib.ADC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.ADC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.

%% C++ class public data member |Dac| for C++ class |MODULE_DESCRIPTION_E440| 
% C++ Signature: DAC_INFO_LUSBAPI MODULE_DESCRIPTION_E440::Dac

addProperty(MODULE_DESCRIPTION_E440Definition, "Dac", "clib.MyCppLib.DAC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DAC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.

%% C++ class public data member |DigitalIo| for C++ class |MODULE_DESCRIPTION_E440| 
% C++ Signature: DIGITAL_IO_INFO_LUSBAPI MODULE_DESCRIPTION_E440::DigitalIo

addProperty(MODULE_DESCRIPTION_E440Definition, "DigitalIo", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E440."); % Modify help description values as needed.

%% C++ class |ADC_PARS_E440| with MATLAB name |clib.MyCppLib.ADC_PARS_E440| 
ADC_PARS_E440Definition = addClass(libDef, "ADC_PARS_E440", "MATLABName", "clib.MyCppLib.ADC_PARS_E440", ...
    "Description", "clib.MyCppLib.ADC_PARS_E440    Representation of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class constructor for C++ class |ADC_PARS_E440| 
% C++ Signature: ADC_PARS_E440::ADC_PARS_E440(ADC_PARS_E440 const & input1)

ADC_PARS_E440Constructor1Definition = addConstructor(ADC_PARS_E440Definition, ...
    "ADC_PARS_E440::ADC_PARS_E440(ADC_PARS_E440 const & input1)", ...
    "Description", "clib.MyCppLib.ADC_PARS_E440 Constructor of C++ class ADC_PARS_E440."); % Modify help description values as needed.
defineArgument(ADC_PARS_E440Constructor1Definition, "input1", "clib.MyCppLib.ADC_PARS_E440", "input");
validate(ADC_PARS_E440Constructor1Definition);

%% C++ class constructor for C++ class |ADC_PARS_E440| 
% C++ Signature: ADC_PARS_E440::ADC_PARS_E440()

ADC_PARS_E440Constructor2Definition = addConstructor(ADC_PARS_E440Definition, ...
    "ADC_PARS_E440::ADC_PARS_E440()", ...
    "Description", "clib.MyCppLib.ADC_PARS_E440 Constructor of C++ class ADC_PARS_E440."); % Modify help description values as needed.
validate(ADC_PARS_E440Constructor2Definition);

%% C++ class public data member |IsAdcEnabled| for C++ class |ADC_PARS_E440| 
% C++ Signature: BOOL ADC_PARS_E440::IsAdcEnabled

addProperty(ADC_PARS_E440Definition, "IsAdcEnabled", "int32", ...
    "Description", "int32    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |IsCorrectionEnabled| for C++ class |ADC_PARS_E440| 
% C++ Signature: BOOL ADC_PARS_E440::IsCorrectionEnabled

addProperty(ADC_PARS_E440Definition, "IsCorrectionEnabled", "int32", ...
    "Description", "int32    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |AdcClockSource| for C++ class |ADC_PARS_E440| 
% C++ Signature: WORD ADC_PARS_E440::AdcClockSource

addProperty(ADC_PARS_E440Definition, "AdcClockSource", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |InputMode| for C++ class |ADC_PARS_E440| 
% C++ Signature: WORD ADC_PARS_E440::InputMode

addProperty(ADC_PARS_E440Definition, "InputMode", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdType| for C++ class |ADC_PARS_E440| 
% C++ Signature: WORD ADC_PARS_E440::SynchroAdType

addProperty(ADC_PARS_E440Definition, "SynchroAdType", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdMode| for C++ class |ADC_PARS_E440| 
% C++ Signature: WORD ADC_PARS_E440::SynchroAdMode

addProperty(ADC_PARS_E440Definition, "SynchroAdMode", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdChannel| for C++ class |ADC_PARS_E440| 
% C++ Signature: WORD ADC_PARS_E440::SynchroAdChannel

addProperty(ADC_PARS_E440Definition, "SynchroAdChannel", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdPorog| for C++ class |ADC_PARS_E440| 
% C++ Signature: SHORT ADC_PARS_E440::SynchroAdPorog

addProperty(ADC_PARS_E440Definition, "SynchroAdPorog", "int16", ...
    "Description", "int16    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |ChannelsQuantity| for C++ class |ADC_PARS_E440| 
% C++ Signature: WORD ADC_PARS_E440::ChannelsQuantity

addProperty(ADC_PARS_E440Definition, "ChannelsQuantity", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |ControlTable| for C++ class |ADC_PARS_E440| 
% C++ Signature: WORD [128] ADC_PARS_E440::ControlTable

addProperty(ADC_PARS_E440Definition, "ControlTable", "clib.array.MyCppLib.UnsignedShort", [128], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
    "Description", "clib.array.MyCppLib.UnsignedShort    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |AdcRate| for C++ class |ADC_PARS_E440| 
% C++ Signature: double ADC_PARS_E440::AdcRate

addProperty(ADC_PARS_E440Definition, "AdcRate", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |InterKadrDelay| for C++ class |ADC_PARS_E440| 
% C++ Signature: double ADC_PARS_E440::InterKadrDelay

addProperty(ADC_PARS_E440Definition, "InterKadrDelay", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |KadrRate| for C++ class |ADC_PARS_E440| 
% C++ Signature: double ADC_PARS_E440::KadrRate

addProperty(ADC_PARS_E440Definition, "KadrRate", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |AdcFifoBaseAddress| for C++ class |ADC_PARS_E440| 
% C++ Signature: WORD ADC_PARS_E440::AdcFifoBaseAddress

addProperty(ADC_PARS_E440Definition, "AdcFifoBaseAddress", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |AdcFifoLength| for C++ class |ADC_PARS_E440| 
% C++ Signature: WORD ADC_PARS_E440::AdcFifoLength

addProperty(ADC_PARS_E440Definition, "AdcFifoLength", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |AdcOffsetCoefs| for C++ class |ADC_PARS_E440| 
% C++ Signature: double [4] ADC_PARS_E440::AdcOffsetCoefs

addProperty(ADC_PARS_E440Definition, "AdcOffsetCoefs", "clib.array.MyCppLib.Double", [4], ... % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
    "Description", "clib.array.MyCppLib.Double    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |AdcScaleCoefs| for C++ class |ADC_PARS_E440| 
% C++ Signature: double [4] ADC_PARS_E440::AdcScaleCoefs

addProperty(ADC_PARS_E440Definition, "AdcScaleCoefs", "clib.array.MyCppLib.Double", [4], ... % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
    "Description", "clib.array.MyCppLib.Double    Data member of C++ class ADC_PARS_E440."); % Modify help description values as needed.

%% C++ class |DAC_PARS_E440| with MATLAB name |clib.MyCppLib.DAC_PARS_E440| 
DAC_PARS_E440Definition = addClass(libDef, "DAC_PARS_E440", "MATLABName", "clib.MyCppLib.DAC_PARS_E440", ...
    "Description", "clib.MyCppLib.DAC_PARS_E440    Representation of C++ class DAC_PARS_E440."); % Modify help description values as needed.

%% C++ class constructor for C++ class |DAC_PARS_E440| 
% C++ Signature: DAC_PARS_E440::DAC_PARS_E440(DAC_PARS_E440 const & input1)

DAC_PARS_E440Constructor1Definition = addConstructor(DAC_PARS_E440Definition, ...
    "DAC_PARS_E440::DAC_PARS_E440(DAC_PARS_E440 const & input1)", ...
    "Description", "clib.MyCppLib.DAC_PARS_E440 Constructor of C++ class DAC_PARS_E440."); % Modify help description values as needed.
defineArgument(DAC_PARS_E440Constructor1Definition, "input1", "clib.MyCppLib.DAC_PARS_E440", "input");
validate(DAC_PARS_E440Constructor1Definition);

%% C++ class constructor for C++ class |DAC_PARS_E440| 
% C++ Signature: DAC_PARS_E440::DAC_PARS_E440()

DAC_PARS_E440Constructor2Definition = addConstructor(DAC_PARS_E440Definition, ...
    "DAC_PARS_E440::DAC_PARS_E440()", ...
    "Description", "clib.MyCppLib.DAC_PARS_E440 Constructor of C++ class DAC_PARS_E440."); % Modify help description values as needed.
validate(DAC_PARS_E440Constructor2Definition);

%% C++ class public data member |DacEnabled| for C++ class |DAC_PARS_E440| 
% C++ Signature: BOOL DAC_PARS_E440::DacEnabled

addProperty(DAC_PARS_E440Definition, "DacEnabled", "int32", ...
    "Description", "int32    Data member of C++ class DAC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |DacRate| for C++ class |DAC_PARS_E440| 
% C++ Signature: double DAC_PARS_E440::DacRate

addProperty(DAC_PARS_E440Definition, "DacRate", "double", ...
    "Description", "double    Data member of C++ class DAC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |DacFifoBaseAddress| for C++ class |DAC_PARS_E440| 
% C++ Signature: WORD DAC_PARS_E440::DacFifoBaseAddress

addProperty(DAC_PARS_E440Definition, "DacFifoBaseAddress", "uint16", ...
    "Description", "uint16    Data member of C++ class DAC_PARS_E440."); % Modify help description values as needed.

%% C++ class public data member |DacFifoLength| for C++ class |DAC_PARS_E440| 
% C++ Signature: WORD DAC_PARS_E440::DacFifoLength

addProperty(DAC_PARS_E440Definition, "DacFifoLength", "uint16", ...
    "Description", "uint16    Data member of C++ class DAC_PARS_E440."); % Modify help description values as needed.

%% C++ class |ILE440| with MATLAB name |clib.MyCppLib.ILE440| 
ILE440Definition = addClass(libDef, "ILE440", "MATLABName", "clib.MyCppLib.ILE440", ...
    "Description", "clib.MyCppLib.ILE440    Representation of C++ class ILE440."); % Modify help description values as needed.

%% C++ class method |RESET_MODULE| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::RESET_MODULE(BYTE ResetFlag = 0)

RESET_MODULEDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::RESET_MODULE(BYTE ResetFlag = 0)", ...
    "MATLABName", "RESET_MODULE", ...
    "Description", "RESET_MODULE Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(RESET_MODULEDefinition, "ResetFlag", "uint8");
defineOutput(RESET_MODULEDefinition, "RetVal", "int32");
validate(RESET_MODULEDefinition);

%% C++ class method |LOAD_MODULE| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::LOAD_MODULE(char const * const FileName = 0)

LOAD_MODULEDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::LOAD_MODULE(char const * const FileName = 0)", ...
   "MATLABName", "LOAD_MODULE", ...
   "Description", "LOAD_MODULE Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(LOAD_MODULEDefinition, "FileName", "string", "input", "nullTerminated"); % <MLTYPE> can be "clib.array.MyCppLib.Char","int8","string", or "char"
defineOutput(LOAD_MODULEDefinition, "RetVal", "int32");
validate(LOAD_MODULEDefinition);

%% C++ class method |TEST_MODULE| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::TEST_MODULE()

TEST_MODULEDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::TEST_MODULE()", ...
    "MATLABName", "TEST_MODULE", ...
    "Description", "TEST_MODULE Method of C++ class ILE440."); % Modify help description values as needed.
defineOutput(TEST_MODULEDefinition, "RetVal", "int32");
validate(TEST_MODULEDefinition);

%% C++ class method |SEND_COMMAND| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::SEND_COMMAND(WORD Command)

SEND_COMMANDDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::SEND_COMMAND(WORD Command)", ...
    "MATLABName", "SEND_COMMAND", ...
    "Description", "SEND_COMMAND Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(SEND_COMMANDDefinition, "Command", "uint16");
defineOutput(SEND_COMMANDDefinition, "RetVal", "int32");
validate(SEND_COMMANDDefinition);

%% C++ class method |GET_ADC_PARS| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::GET_ADC_PARS(ADC_PARS_E440 * const AdcPars)

GET_ADC_PARSDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::GET_ADC_PARS(ADC_PARS_E440 * const AdcPars)", ...
   "MATLABName", "GET_ADC_PARS", ...
   "Description", "GET_ADC_PARS Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(GET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E440", "input", 1); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E440", or "clib.array.MyCppLib.ADC_PARS_E440"
defineOutput(GET_ADC_PARSDefinition, "RetVal", "int32");
validate(GET_ADC_PARSDefinition);

%% C++ class method |SET_ADC_PARS| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::SET_ADC_PARS(ADC_PARS_E440 * const AdcPars)

SET_ADC_PARSDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::SET_ADC_PARS(ADC_PARS_E440 * const AdcPars)", ...
   "MATLABName", "SET_ADC_PARS", ...
   "Description", "SET_ADC_PARS Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(SET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E440", "input", 1); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E440", or "clib.array.MyCppLib.ADC_PARS_E440"
defineOutput(SET_ADC_PARSDefinition, "RetVal", "int32");
validate(SET_ADC_PARSDefinition);

%% C++ class method |START_ADC| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::START_ADC()

START_ADCDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::START_ADC()", ...
    "MATLABName", "START_ADC", ...
    "Description", "START_ADC Method of C++ class ILE440."); % Modify help description values as needed.
defineOutput(START_ADCDefinition, "RetVal", "int32");
validate(START_ADCDefinition);

%% C++ class method |STOP_ADC| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::STOP_ADC()

STOP_ADCDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::STOP_ADC()", ...
    "MATLABName", "STOP_ADC", ...
    "Description", "STOP_ADC Method of C++ class ILE440."); % Modify help description values as needed.
defineOutput(STOP_ADCDefinition, "RetVal", "int32");
validate(STOP_ADCDefinition);

%% C++ class method |ADC_KADR| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::ADC_KADR(SHORT * const Data)

ADC_KADRDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::ADC_KADR(SHORT * const Data)", ...
   "MATLABName", "ADC_KADR", ...
   "Description", "ADC_KADR Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(ADC_KADRDefinition, "Data", "clib.array.MyCppLib.Short", "input", 32); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
defineOutput(ADC_KADRDefinition, "RetVal", "int32");
validate(ADC_KADRDefinition);

%% C++ class method |ADC_SAMPLE| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::ADC_SAMPLE(SHORT * const AdcData,WORD AdcChannel)

ADC_SAMPLEDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::ADC_SAMPLE(SHORT * const AdcData,WORD AdcChannel)", ...
   "MATLABName", "ADC_SAMPLE", ...
   "Description", "ADC_SAMPLE Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(ADC_SAMPLEDefinition, "AdcData", "clib.array.MyCppLib.Short", "input", 1); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
defineArgument(ADC_SAMPLEDefinition, "AdcChannel", "uint16");
defineOutput(ADC_SAMPLEDefinition, "RetVal", "int32");
validate(ADC_SAMPLEDefinition);

%% C++ class method |ReadData| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::ReadData(IO_REQUEST_LUSBAPI * const ReadRequest)

ReadDataDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::ReadData(IO_REQUEST_LUSBAPI * const ReadRequest)", ...
   "MATLABName", "ReadData", ...
   "Description", "ReadData Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(ReadDataDefinition, "ReadRequest", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", 1); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
defineOutput(ReadDataDefinition, "RetVal", "int32");
validate(ReadDataDefinition);

%% C++ class method |GET_DAC_PARS| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::GET_DAC_PARS(DAC_PARS_E440 * const DacPars)

%GET_DAC_PARSDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::GET_DAC_PARS(DAC_PARS_E440 * const DacPars)", ...
%    "MATLABName", "GET_DAC_PARS", ...
%    "Description", "GET_DAC_PARS Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(GET_DAC_PARSDefinition, "DacPars", "clib.MyCppLib.DAC_PARS_E440", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.DAC_PARS_E440", or "clib.array.MyCppLib.DAC_PARS_E440"
%defineOutput(GET_DAC_PARSDefinition, "RetVal", "int32");
%validate(GET_DAC_PARSDefinition);

%% C++ class method |SET_DAC_PARS| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::SET_DAC_PARS(DAC_PARS_E440 * const DacPars)

%SET_DAC_PARSDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::SET_DAC_PARS(DAC_PARS_E440 * const DacPars)", ...
%    "MATLABName", "SET_DAC_PARS", ...
%    "Description", "SET_DAC_PARS Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(SET_DAC_PARSDefinition, "DacPars", "clib.MyCppLib.DAC_PARS_E440", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.DAC_PARS_E440", or "clib.array.MyCppLib.DAC_PARS_E440"
%defineOutput(SET_DAC_PARSDefinition, "RetVal", "int32");
%validate(SET_DAC_PARSDefinition);

%% C++ class method |START_DAC| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::START_DAC()

START_DACDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::START_DAC()", ...
    "MATLABName", "START_DAC", ...
    "Description", "START_DAC Method of C++ class ILE440."); % Modify help description values as needed.
defineOutput(START_DACDefinition, "RetVal", "int32");
validate(START_DACDefinition);

%% C++ class method |STOP_DAC| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::STOP_DAC()

STOP_DACDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::STOP_DAC()", ...
    "MATLABName", "STOP_DAC", ...
    "Description", "STOP_DAC Method of C++ class ILE440."); % Modify help description values as needed.
defineOutput(STOP_DACDefinition, "RetVal", "int32");
validate(STOP_DACDefinition);

%% C++ class method |WriteData| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::WriteData(IO_REQUEST_LUSBAPI * const WriteRequest)

%WriteDataDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::WriteData(IO_REQUEST_LUSBAPI * const WriteRequest)", ...
%    "MATLABName", "WriteData", ...
%    "Description", "WriteData Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(WriteDataDefinition, "WriteRequest", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
%defineOutput(WriteDataDefinition, "RetVal", "int32");
%validate(WriteDataDefinition);

%% C++ class method |DAC_SAMPLE| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::DAC_SAMPLE(SHORT * const DacData,WORD DacChannel)

%DAC_SAMPLEDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::DAC_SAMPLE(SHORT * const DacData,WORD DacChannel)", ...
%    "MATLABName", "DAC_SAMPLE", ...
%    "Description", "DAC_SAMPLE Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(DAC_SAMPLEDefinition, "DacData", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineArgument(DAC_SAMPLEDefinition, "DacChannel", "uint16");
%defineOutput(DAC_SAMPLEDefinition, "RetVal", "int32");
%validate(DAC_SAMPLEDefinition);

%% C++ class method |ENABLE_TTL_OUT| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::ENABLE_TTL_OUT(BOOL EnableTtlOut)

ENABLE_TTL_OUTDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::ENABLE_TTL_OUT(BOOL EnableTtlOut)", ...
    "MATLABName", "ENABLE_TTL_OUT", ...
    "Description", "ENABLE_TTL_OUT Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(ENABLE_TTL_OUTDefinition, "EnableTtlOut", "int32");
defineOutput(ENABLE_TTL_OUTDefinition, "RetVal", "int32");
validate(ENABLE_TTL_OUTDefinition);

%% C++ class method |TTL_IN| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::TTL_IN(WORD * const TtlIn)

%TTL_INDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::TTL_IN(WORD * const TtlIn)", ...
%    "MATLABName", "TTL_IN", ...
%    "Description", "TTL_IN Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(TTL_INDefinition, "TtlIn", "clib.array.MyCppLib.UnsignedShort", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
%defineOutput(TTL_INDefinition, "RetVal", "int32");
%validate(TTL_INDefinition);

%% C++ class method |TTL_OUT| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::TTL_OUT(WORD TtlOut)

TTL_OUTDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::TTL_OUT(WORD TtlOut)", ...
    "MATLABName", "TTL_OUT", ...
    "Description", "TTL_OUT Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(TTL_OUTDefinition, "TtlOut", "uint16");
defineOutput(TTL_OUTDefinition, "RetVal", "int32");
validate(TTL_OUTDefinition);

%% C++ class method |ENABLE_FLASH_WRITE| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::ENABLE_FLASH_WRITE(BOOL EnableFlashWrite)

ENABLE_FLASH_WRITEDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::ENABLE_FLASH_WRITE(BOOL EnableFlashWrite)", ...
    "MATLABName", "ENABLE_FLASH_WRITE", ...
    "Description", "ENABLE_FLASH_WRITE Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(ENABLE_FLASH_WRITEDefinition, "EnableFlashWrite", "int32");
defineOutput(ENABLE_FLASH_WRITEDefinition, "RetVal", "int32");
validate(ENABLE_FLASH_WRITEDefinition);

%% C++ class method |READ_FLASH_WORD| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::READ_FLASH_WORD(WORD FlashAddress,SHORT * const FlashWord)

%READ_FLASH_WORDDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::READ_FLASH_WORD(WORD FlashAddress,SHORT * const FlashWord)", ...
%    "MATLABName", "READ_FLASH_WORD", ...
%    "Description", "READ_FLASH_WORD Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(READ_FLASH_WORDDefinition, "FlashAddress", "uint16");
%defineArgument(READ_FLASH_WORDDefinition, "FlashWord", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineOutput(READ_FLASH_WORDDefinition, "RetVal", "int32");
%validate(READ_FLASH_WORDDefinition);

%% C++ class method |WRITE_FLASH_WORD| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::WRITE_FLASH_WORD(WORD FlashAddress,SHORT FlashWord)

WRITE_FLASH_WORDDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::WRITE_FLASH_WORD(WORD FlashAddress,SHORT FlashWord)", ...
    "MATLABName", "WRITE_FLASH_WORD", ...
    "Description", "WRITE_FLASH_WORD Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(WRITE_FLASH_WORDDefinition, "FlashAddress", "uint16");
defineArgument(WRITE_FLASH_WORDDefinition, "FlashWord", "int16");
defineOutput(WRITE_FLASH_WORDDefinition, "RetVal", "int32");
validate(WRITE_FLASH_WORDDefinition);

%% C++ class method |GET_MODULE_DESCRIPTION| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E440 * const ModuleDescription)

GET_MODULE_DESCRIPTIONDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E440 * const ModuleDescription)", ...
   "MATLABName", "GET_MODULE_DESCRIPTION", ...
   "Description", "GET_MODULE_DESCRIPTION Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(GET_MODULE_DESCRIPTIONDefinition, "ModuleDescription", "clib.MyCppLib.MODULE_DESCRIPTION_E440", "input", 1); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E440", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E440"
defineOutput(GET_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
validate(GET_MODULE_DESCRIPTIONDefinition);

%% C++ class method |SAVE_MODULE_DESCRIPTION| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E440 * const ModuleDescription)

%SAVE_MODULE_DESCRIPTIONDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E440 * const ModuleDescription)", ...
%    "MATLABName", "SAVE_MODULE_DESCRIPTION", ...
%    "Description", "SAVE_MODULE_DESCRIPTION Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(SAVE_MODULE_DESCRIPTIONDefinition, "ModuleDescription", "clib.MyCppLib.MODULE_DESCRIPTION_E440", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E440", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E440"
%defineOutput(SAVE_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
%validate(SAVE_MODULE_DESCRIPTIONDefinition);

%% C++ class method |PUT_LBIOS_WORD| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::PUT_LBIOS_WORD(WORD Address,SHORT Data)

PUT_LBIOS_WORDDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::PUT_LBIOS_WORD(WORD Address,SHORT Data)", ...
    "MATLABName", "PUT_LBIOS_WORD", ...
    "Description", "PUT_LBIOS_WORD Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(PUT_LBIOS_WORDDefinition, "Address", "uint16");
defineArgument(PUT_LBIOS_WORDDefinition, "Data", "int16");
defineOutput(PUT_LBIOS_WORDDefinition, "RetVal", "int32");
validate(PUT_LBIOS_WORDDefinition);

%% C++ class method |GET_LBIOS_WORD| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::GET_LBIOS_WORD(WORD Address,SHORT * const Data)

%GET_LBIOS_WORDDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::GET_LBIOS_WORD(WORD Address,SHORT * const Data)", ...
%    "MATLABName", "GET_LBIOS_WORD", ...
%    "Description", "GET_LBIOS_WORD Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(GET_LBIOS_WORDDefinition, "Address", "uint16");
%defineArgument(GET_LBIOS_WORDDefinition, "Data", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineOutput(GET_LBIOS_WORDDefinition, "RetVal", "int32");
%validate(GET_LBIOS_WORDDefinition);

%% C++ class method |PUT_DM_WORD| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::PUT_DM_WORD(WORD Address,SHORT Data)

PUT_DM_WORDDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::PUT_DM_WORD(WORD Address,SHORT Data)", ...
    "MATLABName", "PUT_DM_WORD", ...
    "Description", "PUT_DM_WORD Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(PUT_DM_WORDDefinition, "Address", "uint16");
defineArgument(PUT_DM_WORDDefinition, "Data", "int16");
defineOutput(PUT_DM_WORDDefinition, "RetVal", "int32");
validate(PUT_DM_WORDDefinition);

%% C++ class method |GET_DM_WORD| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::GET_DM_WORD(WORD Address,SHORT * const Data)

GET_DM_WORDDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::GET_DM_WORD(WORD Address,SHORT * const Data)", ...
   "MATLABName", "GET_DM_WORD", ...
   "Description", "GET_DM_WORD Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(GET_DM_WORDDefinition, "Address", "uint16");
defineArgument(GET_DM_WORDDefinition, "Data", "clib.array.MyCppLib.Short", "input", 1); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
defineOutput(GET_DM_WORDDefinition, "RetVal", "int32");
validate(GET_DM_WORDDefinition);

%% C++ class method |PUT_PM_WORD| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::PUT_PM_WORD(WORD Address,long Data)

PUT_PM_WORDDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::PUT_PM_WORD(WORD Address,long Data)", ...
    "MATLABName", "PUT_PM_WORD", ...
    "Description", "PUT_PM_WORD Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(PUT_PM_WORDDefinition, "Address", "uint16");
defineArgument(PUT_PM_WORDDefinition, "Data", "int32");
defineOutput(PUT_PM_WORDDefinition, "RetVal", "int32");
validate(PUT_PM_WORDDefinition);

% C++ class method |GET_PM_WORD| for C++ class |ILE440| 
%C++ Signature: BOOL ILE440::GET_PM_WORD(WORD Address,long * const Data)

GET_PM_WORDDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::GET_PM_WORD(WORD Address,long * const Data)", ...
   "MATLABName", "GET_PM_WORD", ...
   "Description", "GET_PM_WORD Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(GET_PM_WORDDefinition, "Address", "uint16");
defineArgument(GET_PM_WORDDefinition, "Data", "clib.array.MyCppLib.Long", "input", 1); % <MLTYPE> can be "clib.array.MyCppLib.Long", or "int32"
defineOutput(GET_PM_WORDDefinition, "RetVal", "int32");
validate(GET_PM_WORDDefinition);

% C++ class method |PUT_DM_ARRAY| for C++ class |ILE440| 
%C++ Signature: BOOL ILE440::PUT_DM_ARRAY(WORD BaseAddress,WORD NPoints,SHORT * const Data)

PUT_DM_ARRAYDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::PUT_DM_ARRAY(WORD BaseAddress,WORD NPoints,SHORT * const Data)", ...
   "MATLABName", "PUT_DM_ARRAY", ...
   "Description", "PUT_DM_ARRAY Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(PUT_DM_ARRAYDefinition, "BaseAddress", "uint16");
defineArgument(PUT_DM_ARRAYDefinition, "NPoints", "uint16");
defineArgument(PUT_DM_ARRAYDefinition, "Data", "clib.array.MyCppLib.Short", "input", 1); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
defineOutput(PUT_DM_ARRAYDefinition, "RetVal", "int32");
validate(PUT_DM_ARRAYDefinition);

%% C++ class method |GET_DM_ARRAY| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::GET_DM_ARRAY(WORD BaseAddress,WORD NPoints,SHORT * const Data)

GET_DM_ARRAYDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::GET_DM_ARRAY(WORD BaseAddress,WORD NPoints,SHORT * const Data)", ...
   "MATLABName", "GET_DM_ARRAY", ...
   "Description", "GET_DM_ARRAY Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(GET_DM_ARRAYDefinition, "BaseAddress", "uint16");
defineArgument(GET_DM_ARRAYDefinition, "NPoints", "uint16");
defineArgument(GET_DM_ARRAYDefinition, "Data", "clib.array.MyCppLib.Short", "input", 0x3000) % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
defineOutput(GET_DM_ARRAYDefinition, "RetVal", "int32");
validate(GET_DM_ARRAYDefinition);

% C++ class method |PUT_PM_ARRAY| for C++ class |ILE440| 
%C++ Signature: BOOL ILE440::PUT_PM_ARRAY(WORD BaseAddress,WORD NPoints,long * const Data)

PUT_PM_ARRAYDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::PUT_PM_ARRAY(WORD BaseAddress,WORD NPoints,long * const Data)", ...
   "MATLABName", "PUT_PM_ARRAY", ...
   "Description", "PUT_PM_ARRAY Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(PUT_PM_ARRAYDefinition, "BaseAddress", "uint16");
defineArgument(PUT_PM_ARRAYDefinition, "NPoints", "uint16");
defineArgument(PUT_PM_ARRAYDefinition, "Data", "clib.array.MyCppLib.Long", "input", 64); % <MLTYPE> can be "clib.array.MyCppLib.Long", or "int32"
defineOutput(PUT_PM_ARRAYDefinition, "RetVal", "int32");
validate(PUT_PM_ARRAYDefinition);

% C++ class method |GET_PM_ARRAY| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::GET_PM_ARRAY(WORD BaseAddress,WORD NPoints,long * const Data)

GET_PM_ARRAYDefinition = addMethod(ILE440Definition, ...
   "BOOL ILE440::GET_PM_ARRAY(WORD BaseAddress,WORD NPoints,long * const Data)", ...
   "MATLABName", "GET_PM_ARRAY", ...
   "Description", "GET_PM_ARRAY Method of C++ class ILE440."); % Modify help description values as needed.
defineArgument(GET_PM_ARRAYDefinition, "BaseAddress", "uint16");
defineArgument(GET_PM_ARRAYDefinition, "NPoints", "uint16");
defineArgument(GET_PM_ARRAYDefinition, "Data", "clib.array.MyCppLib.Long", "input", 64); % <MLTYPE> can be "clib.array.MyCppLib.Long", or "int32"
defineOutput(GET_PM_ARRAYDefinition, "RetVal", "int32");
validate(GET_PM_ARRAYDefinition);

%% C++ class method |ERASE_BOOT_FLASH| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::ERASE_BOOT_FLASH()

ERASE_BOOT_FLASHDefinition = addMethod(ILE440Definition, ...
    "BOOL ILE440::ERASE_BOOT_FLASH()", ...
    "MATLABName", "ERASE_BOOT_FLASH", ...
    "Description", "ERASE_BOOT_FLASH Method of C++ class ILE440."); % Modify help description values as needed.
defineOutput(ERASE_BOOT_FLASHDefinition, "RetVal", "int32");
validate(ERASE_BOOT_FLASHDefinition);

%% C++ class method |PUT_ARRAY_BOOT_FLASH| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::PUT_ARRAY_BOOT_FLASH(DWORD BaseAddress,DWORD NBytes,BYTE * Data)

%PUT_ARRAY_BOOT_FLASHDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::PUT_ARRAY_BOOT_FLASH(DWORD BaseAddress,DWORD NBytes,BYTE * Data)", ...
%    "MATLABName", "PUT_ARRAY_BOOT_FLASH", ...
%    "Description", "PUT_ARRAY_BOOT_FLASH Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(PUT_ARRAY_BOOT_FLASHDefinition, "BaseAddress", "uint32");
%defineArgument(PUT_ARRAY_BOOT_FLASHDefinition, "NBytes", "uint32");
%defineArgument(PUT_ARRAY_BOOT_FLASHDefinition, "Data", "clib.array.MyCppLib.UnsignedChar", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
%defineOutput(PUT_ARRAY_BOOT_FLASHDefinition, "RetVal", "int32");
%validate(PUT_ARRAY_BOOT_FLASHDefinition);

%% C++ class method |GET_ARRAY_BOOT_FLASH| for C++ class |ILE440| 
% C++ Signature: BOOL ILE440::GET_ARRAY_BOOT_FLASH(DWORD BaseAddress,DWORD NBytes,BYTE * Data)

%GET_ARRAY_BOOT_FLASHDefinition = addMethod(ILE440Definition, ...
%    "BOOL ILE440::GET_ARRAY_BOOT_FLASH(DWORD BaseAddress,DWORD NBytes,BYTE * Data)", ...
%    "MATLABName", "GET_ARRAY_BOOT_FLASH", ...
%    "Description", "GET_ARRAY_BOOT_FLASH Method of C++ class ILE440."); % Modify help description values as needed.
%defineArgument(GET_ARRAY_BOOT_FLASHDefinition, "BaseAddress", "uint32");
%defineArgument(GET_ARRAY_BOOT_FLASHDefinition, "NBytes", "uint32");
%defineArgument(GET_ARRAY_BOOT_FLASHDefinition, "Data", "clib.array.MyCppLib.UnsignedChar", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
%defineOutput(GET_ARRAY_BOOT_FLASHDefinition, "RetVal", "int32");
%validate(GET_ARRAY_BOOT_FLASHDefinition);

%% C++ class |MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>| with MATLAB name |clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_| 
MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_Definition = addClass(libDef, "MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>", "MATLABName", "clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_    Representation of C++ class MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class constructor for C++ class |MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>| 
% C++ Signature: MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>::MCU_INFO_LUSBAPI(MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI> const & input1)

MCU_INFO_LUSBAPI_MCU_VERSION_INFConstructor1Definition = addConstructor(MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_Definition, ...
    "MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>::MCU_INFO_LUSBAPI(MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI> const & input1)", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_ Constructor of C++ class MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.
defineArgument(MCU_INFO_LUSBAPI_MCU_VERSION_INFConstructor1Definition, "input1", "clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_", "input");
validate(MCU_INFO_LUSBAPI_MCU_VERSION_INFConstructor1Definition);

%% C++ class constructor for C++ class |MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>| 
% C++ Signature: MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>::MCU_INFO_LUSBAPI()

MCU_INFO_LUSBAPI_MCU_VERSION_INFConstructor2Definition = addConstructor(MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_Definition, ...
    "MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>::MCU_INFO_LUSBAPI()", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_ Constructor of C++ class MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.
validate(MCU_INFO_LUSBAPI_MCU_VERSION_INFConstructor2Definition);

%% C++ class public data member |Active| for C++ class |MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>| 
% C++ Signature: BOOL MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>::Active

addProperty(MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_Definition, "Active", "int32", ...
    "Description", "int32    Data member of C++ class MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class public data member |Name| for C++ class |MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>| 
% C++ Signature: BYTE [25] MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>::Name

addProperty(MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_Definition, "Name", "clib.array.MyCppLib.UnsignedChar", [25], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class public data member |ClockRate| for C++ class |MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>| 
% C++ Signature: double MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>::ClockRate

addProperty(MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_Definition, "ClockRate", "double", ...
    "Description", "double    Data member of C++ class MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class public data member |Version| for C++ class |MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>| 
% C++ Signature: MCU_VERSION_INFO_LUSBAPI MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>::Version

addProperty(MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_Definition, "Version", "clib.MyCppLib.MCU_VERSION_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.MCU_VERSION_INFO_LUSBAPI    Data member of C++ class MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class public data member |Comment| for C++ class |MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>| 
% C++ Signature: BYTE [256] MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>::Comment

addProperty(MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_Definition, "Comment", "clib.array.MyCppLib.UnsignedChar", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI>."); % Modify help description values as needed.

%% C++ class |MODULE_DESCRIPTION_E2010| with MATLAB name |clib.MyCppLib.MODULE_DESCRIPTION_E2010| 
MODULE_DESCRIPTION_E2010Definition = addClass(libDef, "MODULE_DESCRIPTION_E2010", "MATLABName", "clib.MyCppLib.MODULE_DESCRIPTION_E2010", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E2010    Representation of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E2010| 
% C++ Signature: MODULE_DESCRIPTION_E2010::MODULE_DESCRIPTION_E2010(MODULE_DESCRIPTION_E2010 const & input1)

MODULE_DESCRIPTION_E2010Constructor1Definition = addConstructor(MODULE_DESCRIPTION_E2010Definition, ...
    "MODULE_DESCRIPTION_E2010::MODULE_DESCRIPTION_E2010(MODULE_DESCRIPTION_E2010 const & input1)", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E2010 Constructor of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.
defineArgument(MODULE_DESCRIPTION_E2010Constructor1Definition, "input1", "clib.MyCppLib.MODULE_DESCRIPTION_E2010", "input");
validate(MODULE_DESCRIPTION_E2010Constructor1Definition);

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E2010| 
% C++ Signature: MODULE_DESCRIPTION_E2010::MODULE_DESCRIPTION_E2010()

MODULE_DESCRIPTION_E2010Constructor2Definition = addConstructor(MODULE_DESCRIPTION_E2010Definition, ...
    "MODULE_DESCRIPTION_E2010::MODULE_DESCRIPTION_E2010()", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E2010 Constructor of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.
validate(MODULE_DESCRIPTION_E2010Constructor2Definition);

%% C++ class public data member |Module| for C++ class |MODULE_DESCRIPTION_E2010| 
% C++ Signature: MODULE_INFO_LUSBAPI MODULE_DESCRIPTION_E2010::Module

addProperty(MODULE_DESCRIPTION_E2010Definition, "Module", "clib.MyCppLib.MODULE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.MODULE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.

%% C++ class public data member |Interface| for C++ class |MODULE_DESCRIPTION_E2010| 
% C++ Signature: INTERFACE_INFO_LUSBAPI MODULE_DESCRIPTION_E2010::Interface

addProperty(MODULE_DESCRIPTION_E2010Definition, "Interface", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.

%% C++ class public data member |Mcu| for C++ class |MODULE_DESCRIPTION_E2010| 
% C++ Signature: MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI> MODULE_DESCRIPTION_E2010::Mcu

addProperty(MODULE_DESCRIPTION_E2010Definition, "Mcu", "clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_    Data member of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.

%% C++ class public data member |Pld| for C++ class |MODULE_DESCRIPTION_E2010| 
% C++ Signature: PLD_INFO_LUSBAPI MODULE_DESCRIPTION_E2010::Pld

addProperty(MODULE_DESCRIPTION_E2010Definition, "Pld", "clib.MyCppLib.PLD_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.PLD_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.

%% C++ class public data member |Adc| for C++ class |MODULE_DESCRIPTION_E2010| 
% C++ Signature: ADC_INFO_LUSBAPI MODULE_DESCRIPTION_E2010::Adc

addProperty(MODULE_DESCRIPTION_E2010Definition, "Adc", "clib.MyCppLib.ADC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.ADC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.

%% C++ class public data member |Dac| for C++ class |MODULE_DESCRIPTION_E2010| 
% C++ Signature: DAC_INFO_LUSBAPI MODULE_DESCRIPTION_E2010::Dac

addProperty(MODULE_DESCRIPTION_E2010Definition, "Dac", "clib.MyCppLib.DAC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DAC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.

%% C++ class public data member |DigitalIo| for C++ class |MODULE_DESCRIPTION_E2010| 
% C++ Signature: DIGITAL_IO_INFO_LUSBAPI MODULE_DESCRIPTION_E2010::DigitalIo

addProperty(MODULE_DESCRIPTION_E2010Definition, "DigitalIo", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E2010."); % Modify help description values as needed.

%% C++ class |USER_FLASH_E2010| with MATLAB name |clib.MyCppLib.USER_FLASH_E2010| 
USER_FLASH_E2010Definition = addClass(libDef, "USER_FLASH_E2010", "MATLABName", "clib.MyCppLib.USER_FLASH_E2010", ...
    "Description", "clib.MyCppLib.USER_FLASH_E2010    Representation of C++ class USER_FLASH_E2010."); % Modify help description values as needed.

%% C++ class constructor for C++ class |USER_FLASH_E2010| 
% C++ Signature: USER_FLASH_E2010::USER_FLASH_E2010(USER_FLASH_E2010 const & input1)

USER_FLASH_E2010Constructor1Definition = addConstructor(USER_FLASH_E2010Definition, ...
    "USER_FLASH_E2010::USER_FLASH_E2010(USER_FLASH_E2010 const & input1)", ...
    "Description", "clib.MyCppLib.USER_FLASH_E2010 Constructor of C++ class USER_FLASH_E2010."); % Modify help description values as needed.
defineArgument(USER_FLASH_E2010Constructor1Definition, "input1", "clib.MyCppLib.USER_FLASH_E2010", "input");
validate(USER_FLASH_E2010Constructor1Definition);

%% C++ class constructor for C++ class |USER_FLASH_E2010| 
% C++ Signature: USER_FLASH_E2010::USER_FLASH_E2010()

USER_FLASH_E2010Constructor2Definition = addConstructor(USER_FLASH_E2010Definition, ...
    "USER_FLASH_E2010::USER_FLASH_E2010()", ...
    "Description", "clib.MyCppLib.USER_FLASH_E2010 Constructor of C++ class USER_FLASH_E2010."); % Modify help description values as needed.
validate(USER_FLASH_E2010Constructor2Definition);

%% C++ class public data member |Buffer| for C++ class |USER_FLASH_E2010| 
% C++ Signature: BYTE [512] USER_FLASH_E2010::Buffer

addProperty(USER_FLASH_E2010Definition, "Buffer", "clib.array.MyCppLib.UnsignedChar", [512], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class USER_FLASH_E2010."); % Modify help description values as needed.

%% C++ class |SYNCHRO_PARS_E2010| with MATLAB name |clib.MyCppLib.SYNCHRO_PARS_E2010| 
SYNCHRO_PARS_E2010Definition = addClass(libDef, "SYNCHRO_PARS_E2010", "MATLABName", "clib.MyCppLib.SYNCHRO_PARS_E2010", ...
    "Description", "clib.MyCppLib.SYNCHRO_PARS_E2010    Representation of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.

%% C++ class constructor for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: SYNCHRO_PARS_E2010::SYNCHRO_PARS_E2010(SYNCHRO_PARS_E2010 const & input1)

SYNCHRO_PARS_E2010Constructor1Definition = addConstructor(SYNCHRO_PARS_E2010Definition, ...
    "SYNCHRO_PARS_E2010::SYNCHRO_PARS_E2010(SYNCHRO_PARS_E2010 const & input1)", ...
    "Description", "clib.MyCppLib.SYNCHRO_PARS_E2010 Constructor of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.
defineArgument(SYNCHRO_PARS_E2010Constructor1Definition, "input1", "clib.MyCppLib.SYNCHRO_PARS_E2010", "input");
validate(SYNCHRO_PARS_E2010Constructor1Definition);

%% C++ class constructor for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: SYNCHRO_PARS_E2010::SYNCHRO_PARS_E2010()

SYNCHRO_PARS_E2010Constructor2Definition = addConstructor(SYNCHRO_PARS_E2010Definition, ...
    "SYNCHRO_PARS_E2010::SYNCHRO_PARS_E2010()", ...
    "Description", "clib.MyCppLib.SYNCHRO_PARS_E2010 Constructor of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.
validate(SYNCHRO_PARS_E2010Constructor2Definition);

%% C++ class public data member |StartSource| for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: WORD SYNCHRO_PARS_E2010::StartSource

addProperty(SYNCHRO_PARS_E2010Definition, "StartSource", "uint16", ...
    "Description", "uint16    Data member of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |StartDelay| for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: DWORD SYNCHRO_PARS_E2010::StartDelay

addProperty(SYNCHRO_PARS_E2010Definition, "StartDelay", "uint32", ...
    "Description", "uint32    Data member of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |SynhroSource| for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: WORD SYNCHRO_PARS_E2010::SynhroSource

addProperty(SYNCHRO_PARS_E2010Definition, "SynhroSource", "uint16", ...
    "Description", "uint16    Data member of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |StopAfterNKadrs| for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: DWORD SYNCHRO_PARS_E2010::StopAfterNKadrs

addProperty(SYNCHRO_PARS_E2010Definition, "StopAfterNKadrs", "uint32", ...
    "Description", "uint32    Data member of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdMode| for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: WORD SYNCHRO_PARS_E2010::SynchroAdMode

addProperty(SYNCHRO_PARS_E2010Definition, "SynchroAdMode", "uint16", ...
    "Description", "uint16    Data member of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdChannel| for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: WORD SYNCHRO_PARS_E2010::SynchroAdChannel

addProperty(SYNCHRO_PARS_E2010Definition, "SynchroAdChannel", "uint16", ...
    "Description", "uint16    Data member of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |SynchroAdPorog| for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: SHORT SYNCHRO_PARS_E2010::SynchroAdPorog

addProperty(SYNCHRO_PARS_E2010Definition, "SynchroAdPorog", "int16", ...
    "Description", "int16    Data member of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |IsBlockDataMarkerEnabled| for C++ class |SYNCHRO_PARS_E2010| 
% C++ Signature: BYTE SYNCHRO_PARS_E2010::IsBlockDataMarkerEnabled

addProperty(SYNCHRO_PARS_E2010Definition, "IsBlockDataMarkerEnabled", "uint8", ...
    "Description", "uint8    Data member of C++ class SYNCHRO_PARS_E2010."); % Modify help description values as needed.

%% C++ class |ADC_PARS_E2010| with MATLAB name |clib.MyCppLib.ADC_PARS_E2010| 
ADC_PARS_E2010Definition = addClass(libDef, "ADC_PARS_E2010", "MATLABName", "clib.MyCppLib.ADC_PARS_E2010", ...
    "Description", "clib.MyCppLib.ADC_PARS_E2010    Representation of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class constructor for C++ class |ADC_PARS_E2010| 
% C++ Signature: ADC_PARS_E2010::ADC_PARS_E2010(ADC_PARS_E2010 const & input1)

ADC_PARS_E2010Constructor1Definition = addConstructor(ADC_PARS_E2010Definition, ...
    "ADC_PARS_E2010::ADC_PARS_E2010(ADC_PARS_E2010 const & input1)", ...
    "Description", "clib.MyCppLib.ADC_PARS_E2010 Constructor of C++ class ADC_PARS_E2010."); % Modify help description values as needed.
defineArgument(ADC_PARS_E2010Constructor1Definition, "input1", "clib.MyCppLib.ADC_PARS_E2010", "input");
validate(ADC_PARS_E2010Constructor1Definition);

%% C++ class constructor for C++ class |ADC_PARS_E2010| 
% C++ Signature: ADC_PARS_E2010::ADC_PARS_E2010()

ADC_PARS_E2010Constructor2Definition = addConstructor(ADC_PARS_E2010Definition, ...
    "ADC_PARS_E2010::ADC_PARS_E2010()", ...
    "Description", "clib.MyCppLib.ADC_PARS_E2010 Constructor of C++ class ADC_PARS_E2010."); % Modify help description values as needed.
validate(ADC_PARS_E2010Constructor2Definition);

%% C++ class public data member |IsAdcCorrectionEnabled| for C++ class |ADC_PARS_E2010| 
% C++ Signature: BOOL ADC_PARS_E2010::IsAdcCorrectionEnabled

addProperty(ADC_PARS_E2010Definition, "IsAdcCorrectionEnabled", "int32", ...
    "Description", "int32    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |OverloadMode| for C++ class |ADC_PARS_E2010| 
% C++ Signature: WORD ADC_PARS_E2010::OverloadMode

addProperty(ADC_PARS_E2010Definition, "OverloadMode", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |InputCurrentControl| for C++ class |ADC_PARS_E2010| 
% C++ Signature: WORD ADC_PARS_E2010::InputCurrentControl

addProperty(ADC_PARS_E2010Definition, "InputCurrentControl", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |SynchroPars| for C++ class |ADC_PARS_E2010| 
% C++ Signature: SYNCHRO_PARS_E2010 ADC_PARS_E2010::SynchroPars

addProperty(ADC_PARS_E2010Definition, "SynchroPars", "clib.MyCppLib.SYNCHRO_PARS_E2010", ...
    "Description", "clib.MyCppLib.SYNCHRO_PARS_E2010    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |ChannelsQuantity| for C++ class |ADC_PARS_E2010| 
% C++ Signature: WORD ADC_PARS_E2010::ChannelsQuantity

addProperty(ADC_PARS_E2010Definition, "ChannelsQuantity", "uint16", ...
    "Description", "uint16    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |ControlTable| for C++ class |ADC_PARS_E2010| 
% C++ Signature: WORD [256] ADC_PARS_E2010::ControlTable

addProperty(ADC_PARS_E2010Definition, "ControlTable", "clib.array.MyCppLib.UnsignedShort", [256], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
    "Description", "clib.array.MyCppLib.UnsignedShort    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |InputRange| for C++ class |ADC_PARS_E2010| 
% C++ Signature: WORD [4] ADC_PARS_E2010::InputRange

addProperty(ADC_PARS_E2010Definition, "InputRange", "clib.array.MyCppLib.UnsignedShort", [4], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
    "Description", "clib.array.MyCppLib.UnsignedShort    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |InputSwitch| for C++ class |ADC_PARS_E2010| 
% C++ Signature: WORD [4] ADC_PARS_E2010::InputSwitch

addProperty(ADC_PARS_E2010Definition, "InputSwitch", "clib.array.MyCppLib.UnsignedShort", [4], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
    "Description", "clib.array.MyCppLib.UnsignedShort    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |AdcRate| for C++ class |ADC_PARS_E2010| 
% C++ Signature: double ADC_PARS_E2010::AdcRate

addProperty(ADC_PARS_E2010Definition, "AdcRate", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |InterKadrDelay| for C++ class |ADC_PARS_E2010| 
% C++ Signature: double ADC_PARS_E2010::InterKadrDelay

addProperty(ADC_PARS_E2010Definition, "InterKadrDelay", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class public data member |KadrRate| for C++ class |ADC_PARS_E2010| 
% C++ Signature: double ADC_PARS_E2010::KadrRate

addProperty(ADC_PARS_E2010Definition, "KadrRate", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E2010."); % Modify help description values as needed.

%% C++ class |DATA_STATE_E2010| with MATLAB name |clib.MyCppLib.DATA_STATE_E2010| 
DATA_STATE_E2010Definition = addClass(libDef, "DATA_STATE_E2010", "MATLABName", "clib.MyCppLib.DATA_STATE_E2010", ...
    "Description", "clib.MyCppLib.DATA_STATE_E2010    Representation of C++ class DATA_STATE_E2010."); % Modify help description values as needed.

%% C++ class constructor for C++ class |DATA_STATE_E2010| 
% C++ Signature: DATA_STATE_E2010::DATA_STATE_E2010(DATA_STATE_E2010 const & input1)

DATA_STATE_E2010Constructor1Definition = addConstructor(DATA_STATE_E2010Definition, ...
    "DATA_STATE_E2010::DATA_STATE_E2010(DATA_STATE_E2010 const & input1)", ...
    "Description", "clib.MyCppLib.DATA_STATE_E2010 Constructor of C++ class DATA_STATE_E2010."); % Modify help description values as needed.
defineArgument(DATA_STATE_E2010Constructor1Definition, "input1", "clib.MyCppLib.DATA_STATE_E2010", "input");
validate(DATA_STATE_E2010Constructor1Definition);

%% C++ class constructor for C++ class |DATA_STATE_E2010| 
% C++ Signature: DATA_STATE_E2010::DATA_STATE_E2010()

DATA_STATE_E2010Constructor2Definition = addConstructor(DATA_STATE_E2010Definition, ...
    "DATA_STATE_E2010::DATA_STATE_E2010()", ...
    "Description", "clib.MyCppLib.DATA_STATE_E2010 Constructor of C++ class DATA_STATE_E2010."); % Modify help description values as needed.
validate(DATA_STATE_E2010Constructor2Definition);

%% C++ class public data member |ChannelsOverFlow| for C++ class |DATA_STATE_E2010| 
% C++ Signature: BYTE DATA_STATE_E2010::ChannelsOverFlow

addProperty(DATA_STATE_E2010Definition, "ChannelsOverFlow", "uint8", ...
    "Description", "uint8    Data member of C++ class DATA_STATE_E2010."); % Modify help description values as needed.

%% C++ class public data member |BufferOverrun| for C++ class |DATA_STATE_E2010| 
% C++ Signature: BYTE DATA_STATE_E2010::BufferOverrun

addProperty(DATA_STATE_E2010Definition, "BufferOverrun", "uint8", ...
    "Description", "uint8    Data member of C++ class DATA_STATE_E2010."); % Modify help description values as needed.

%% C++ class public data member |CurBufferFilling| for C++ class |DATA_STATE_E2010| 
% C++ Signature: DWORD DATA_STATE_E2010::CurBufferFilling

addProperty(DATA_STATE_E2010Definition, "CurBufferFilling", "uint32", ...
    "Description", "uint32    Data member of C++ class DATA_STATE_E2010."); % Modify help description values as needed.

%% C++ class public data member |MaxOfBufferFilling| for C++ class |DATA_STATE_E2010| 
% C++ Signature: DWORD DATA_STATE_E2010::MaxOfBufferFilling

addProperty(DATA_STATE_E2010Definition, "MaxOfBufferFilling", "uint32", ...
    "Description", "uint32    Data member of C++ class DATA_STATE_E2010."); % Modify help description values as needed.

%% C++ class public data member |BufferSize| for C++ class |DATA_STATE_E2010| 
% C++ Signature: DWORD DATA_STATE_E2010::BufferSize

addProperty(DATA_STATE_E2010Definition, "BufferSize", "uint32", ...
    "Description", "uint32    Data member of C++ class DATA_STATE_E2010."); % Modify help description values as needed.

%% C++ class public data member |CurBufferFillingPercent| for C++ class |DATA_STATE_E2010| 
% C++ Signature: double DATA_STATE_E2010::CurBufferFillingPercent

addProperty(DATA_STATE_E2010Definition, "CurBufferFillingPercent", "double", ...
    "Description", "double    Data member of C++ class DATA_STATE_E2010."); % Modify help description values as needed.

%% C++ class public data member |MaxOfBufferFillingPercent| for C++ class |DATA_STATE_E2010| 
% C++ Signature: double DATA_STATE_E2010::MaxOfBufferFillingPercent

addProperty(DATA_STATE_E2010Definition, "MaxOfBufferFillingPercent", "double", ...
    "Description", "double    Data member of C++ class DATA_STATE_E2010."); % Modify help description values as needed.

% %% C++ class |_BITS_| with MATLAB name |clib.MyCppLib.x_BITS_| 
% x_BITS_Definition = addClass(libDef, "_BITS_", "MATLABName", "clib.MyCppLib.x_BITS_", ...
%     "Description", "clib.MyCppLib.x_BITS_    Representation of C++ class _BITS_."); % Modify help description values as needed.
% 
% %% C++ class constructor for C++ class |_BITS_| 
% % C++ Signature: _BITS_::_BITS_(_BITS_ const & input1)
% 
% x_BITS_Constructor1Definition = addConstructor(x_BITS_Definition, ...
%     "_BITS_::_BITS_(_BITS_ const & input1)", ...
%     "Description", "clib.MyCppLib.x_BITS_ Constructor of C++ class _BITS_."); % Modify help description values as needed.
% defineArgument(x_BITS_Constructor1Definition, "input1", "clib.MyCppLib.x_BITS_", "input");
% validate(x_BITS_Constructor1Definition);
% 
% %% C++ class constructor for C++ class |_BITS_| 
% % C++ Signature: _BITS_::_BITS_()
% 
% x_BITS_Constructor2Definition = addConstructor(x_BITS_Definition, ...
%     "_BITS_::_BITS_()", ...
%     "Description", "clib.MyCppLib.x_BITS_ Constructor of C++ class _BITS_."); % Modify help description values as needed.
% validate(x_BITS_Constructor2Definition);
% 
% %% C++ class public data member |LowPassFilterType| for C++ class |_BITS_| 
% % C++ Signature: BYTE _BITS_::LowPassFilterType
% 
% addProperty(x_BITS_Definition, "LowPassFilterType", "uint8", ...
%     "Description", "uint8    Data member of C++ class _BITS_."); % Modify help description values as needed.
% 
% %% C++ class public data member |ModuleTemperatureGrade| for C++ class |_BITS_| 
% % C++ Signature: BYTE _BITS_::ModuleTemperatureGrade
% 
% addProperty(x_BITS_Definition, "ModuleTemperatureGrade", "uint8", ...
%     "Description", "uint8    Data member of C++ class _BITS_."); % Modify help description values as needed.
% 
% %% C++ class public data member |PldTemperatureGrade| for C++ class |_BITS_| 
% % C++ Signature: BYTE _BITS_::PldTemperatureGrade
% 
% addProperty(x_BITS_Definition, "PldTemperatureGrade", "uint8", ...
%     "Description", "uint8    Data member of C++ class _BITS_."); % Modify help description values as needed.
% 
% %% C++ class public data member |RESERVED| for C++ class |_BITS_| 
% % C++ Signature: BYTE _BITS_::RESERVED
% 
% addProperty(x_BITS_Definition, "RESERVED", "uint8", ...
%     "Description", "uint8    Data member of C++ class _BITS_."); % Modify help description values as needed.

%% C++ class |ILE2010| with MATLAB name |clib.MyCppLib.ILE2010| 
ILE2010Definition = addClass(libDef, "ILE2010", "MATLABName", "clib.MyCppLib.ILE2010", ...
    "Description", "clib.MyCppLib.ILE2010    Representation of C++ class ILE2010."); % Modify help description values as needed.

%% C++ class method |LOAD_MODULE| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::LOAD_MODULE(char const * const FileName = 0)

%LOAD_MODULEDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::LOAD_MODULE(char const * const FileName = 0)", ...
%    "MATLABName", "LOAD_MODULE", ...
%    "Description", "LOAD_MODULE Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(LOAD_MODULEDefinition, "FileName", <MLTYPE>, "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Char","int8","string", or "char"
%defineOutput(LOAD_MODULEDefinition, "RetVal", "int32");
%validate(LOAD_MODULEDefinition);

%% C++ class method |TEST_MODULE| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::TEST_MODULE(WORD TestModeMask = 0)

TEST_MODULEDefinition = addMethod(ILE2010Definition, ...
    "BOOL ILE2010::TEST_MODULE(WORD TestModeMask = 0)", ...
    "MATLABName", "TEST_MODULE", ...
    "Description", "TEST_MODULE Method of C++ class ILE2010."); % Modify help description values as needed.
defineArgument(TEST_MODULEDefinition, "TestModeMask", "uint16");
defineOutput(TEST_MODULEDefinition, "RetVal", "int32");
validate(TEST_MODULEDefinition);

%% C++ class method |GET_ADC_PARS| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::GET_ADC_PARS(ADC_PARS_E2010 * const AdcPars)

%GET_ADC_PARSDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::GET_ADC_PARS(ADC_PARS_E2010 * const AdcPars)", ...
%    "MATLABName", "GET_ADC_PARS", ...
%    "Description", "GET_ADC_PARS Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(GET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E2010", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E2010", or "clib.array.MyCppLib.ADC_PARS_E2010"
%defineOutput(GET_ADC_PARSDefinition, "RetVal", "int32");
%validate(GET_ADC_PARSDefinition);

%% C++ class method |SET_ADC_PARS| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::SET_ADC_PARS(ADC_PARS_E2010 * const AdcPars)

%SET_ADC_PARSDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::SET_ADC_PARS(ADC_PARS_E2010 * const AdcPars)", ...
%    "MATLABName", "SET_ADC_PARS", ...
%    "Description", "SET_ADC_PARS Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(SET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E2010", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E2010", or "clib.array.MyCppLib.ADC_PARS_E2010"
%defineOutput(SET_ADC_PARSDefinition, "RetVal", "int32");
%validate(SET_ADC_PARSDefinition);

%% C++ class method |START_ADC| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::START_ADC()

START_ADCDefinition = addMethod(ILE2010Definition, ...
    "BOOL ILE2010::START_ADC()", ...
    "MATLABName", "START_ADC", ...
    "Description", "START_ADC Method of C++ class ILE2010."); % Modify help description values as needed.
defineOutput(START_ADCDefinition, "RetVal", "int32");
validate(START_ADCDefinition);

%% C++ class method |STOP_ADC| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::STOP_ADC()

STOP_ADCDefinition = addMethod(ILE2010Definition, ...
    "BOOL ILE2010::STOP_ADC()", ...
    "MATLABName", "STOP_ADC", ...
    "Description", "STOP_ADC Method of C++ class ILE2010."); % Modify help description values as needed.
defineOutput(STOP_ADCDefinition, "RetVal", "int32");
validate(STOP_ADCDefinition);

%% C++ class method |GET_DATA_STATE| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::GET_DATA_STATE(DATA_STATE_E2010 * const DataState)

%GET_DATA_STATEDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::GET_DATA_STATE(DATA_STATE_E2010 * const DataState)", ...
%    "MATLABName", "GET_DATA_STATE", ...
%    "Description", "GET_DATA_STATE Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(GET_DATA_STATEDefinition, "DataState", "clib.MyCppLib.DATA_STATE_E2010", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.DATA_STATE_E2010", or "clib.array.MyCppLib.DATA_STATE_E2010"
%defineOutput(GET_DATA_STATEDefinition, "RetVal", "int32");
%validate(GET_DATA_STATEDefinition);

%% C++ class method |ReadData| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::ReadData(IO_REQUEST_LUSBAPI * const ReadRequest)

%ReadDataDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::ReadData(IO_REQUEST_LUSBAPI * const ReadRequest)", ...
%    "MATLABName", "ReadData", ...
%    "Description", "ReadData Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(ReadDataDefinition, "ReadRequest", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
%defineOutput(ReadDataDefinition, "RetVal", "int32");
%validate(ReadDataDefinition);

%% C++ class method |DAC_SAMPLE| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::DAC_SAMPLE(SHORT * const DacData,WORD DacChannel)

%DAC_SAMPLEDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::DAC_SAMPLE(SHORT * const DacData,WORD DacChannel)", ...
%    "MATLABName", "DAC_SAMPLE", ...
%    "Description", "DAC_SAMPLE Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(DAC_SAMPLEDefinition, "DacData", "clib.array.MyCppLib.Short", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
%defineArgument(DAC_SAMPLEDefinition, "DacChannel", "uint16");
%defineOutput(DAC_SAMPLEDefinition, "RetVal", "int32");
%validate(DAC_SAMPLEDefinition);

%% C++ class method |ENABLE_TTL_OUT| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::ENABLE_TTL_OUT(BOOL EnableTtlOut)

ENABLE_TTL_OUTDefinition = addMethod(ILE2010Definition, ...
    "BOOL ILE2010::ENABLE_TTL_OUT(BOOL EnableTtlOut)", ...
    "MATLABName", "ENABLE_TTL_OUT", ...
    "Description", "ENABLE_TTL_OUT Method of C++ class ILE2010."); % Modify help description values as needed.
defineArgument(ENABLE_TTL_OUTDefinition, "EnableTtlOut", "int32");
defineOutput(ENABLE_TTL_OUTDefinition, "RetVal", "int32");
validate(ENABLE_TTL_OUTDefinition);

%% C++ class method |TTL_IN| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::TTL_IN(WORD * const TtlIn)

%TTL_INDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::TTL_IN(WORD * const TtlIn)", ...
%    "MATLABName", "TTL_IN", ...
%    "Description", "TTL_IN Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(TTL_INDefinition, "TtlIn", "clib.array.MyCppLib.UnsignedShort", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
%defineOutput(TTL_INDefinition, "RetVal", "int32");
%validate(TTL_INDefinition);

%% C++ class method |TTL_OUT| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::TTL_OUT(WORD TtlOut)

TTL_OUTDefinition = addMethod(ILE2010Definition, ...
    "BOOL ILE2010::TTL_OUT(WORD TtlOut)", ...
    "MATLABName", "TTL_OUT", ...
    "Description", "TTL_OUT Method of C++ class ILE2010."); % Modify help description values as needed.
defineArgument(TTL_OUTDefinition, "TtlOut", "uint16");
defineOutput(TTL_OUTDefinition, "RetVal", "int32");
validate(TTL_OUTDefinition);

%% C++ class method |ENABLE_FLASH_WRITE| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::ENABLE_FLASH_WRITE(BOOL IsUserFlashWriteEnabled)

ENABLE_FLASH_WRITEDefinition = addMethod(ILE2010Definition, ...
    "BOOL ILE2010::ENABLE_FLASH_WRITE(BOOL IsUserFlashWriteEnabled)", ...
    "MATLABName", "ENABLE_FLASH_WRITE", ...
    "Description", "ENABLE_FLASH_WRITE Method of C++ class ILE2010."); % Modify help description values as needed.
defineArgument(ENABLE_FLASH_WRITEDefinition, "IsUserFlashWriteEnabled", "int32");
defineOutput(ENABLE_FLASH_WRITEDefinition, "RetVal", "int32");
validate(ENABLE_FLASH_WRITEDefinition);

%% C++ class method |READ_FLASH_ARRAY| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::READ_FLASH_ARRAY(USER_FLASH_E2010 * const UserFlash)

%READ_FLASH_ARRAYDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::READ_FLASH_ARRAY(USER_FLASH_E2010 * const UserFlash)", ...
%    "MATLABName", "READ_FLASH_ARRAY", ...
%    "Description", "READ_FLASH_ARRAY Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(READ_FLASH_ARRAYDefinition, "UserFlash", "clib.MyCppLib.USER_FLASH_E2010", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.USER_FLASH_E2010", or "clib.array.MyCppLib.USER_FLASH_E2010"
%defineOutput(READ_FLASH_ARRAYDefinition, "RetVal", "int32");
%validate(READ_FLASH_ARRAYDefinition);

%% C++ class method |WRITE_FLASH_ARRAY| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::WRITE_FLASH_ARRAY(USER_FLASH_E2010 * const UserFlash)

%WRITE_FLASH_ARRAYDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::WRITE_FLASH_ARRAY(USER_FLASH_E2010 * const UserFlash)", ...
%    "MATLABName", "WRITE_FLASH_ARRAY", ...
%    "Description", "WRITE_FLASH_ARRAY Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(WRITE_FLASH_ARRAYDefinition, "UserFlash", "clib.MyCppLib.USER_FLASH_E2010", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.USER_FLASH_E2010", or "clib.array.MyCppLib.USER_FLASH_E2010"
%defineOutput(WRITE_FLASH_ARRAYDefinition, "RetVal", "int32");
%validate(WRITE_FLASH_ARRAYDefinition);

%% C++ class method |GET_MODULE_DESCRIPTION| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E2010 * const ModuleDescription)

%GET_MODULE_DESCRIPTIONDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E2010 * const ModuleDescription)", ...
%    "MATLABName", "GET_MODULE_DESCRIPTION", ...
%    "Description", "GET_MODULE_DESCRIPTION Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(GET_MODULE_DESCRIPTIONDefinition, "ModuleDescription", "clib.MyCppLib.MODULE_DESCRIPTION_E2010", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E2010", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E2010"
%defineOutput(GET_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
%validate(GET_MODULE_DESCRIPTIONDefinition);

%% C++ class method |SAVE_MODULE_DESCRIPTION| for C++ class |ILE2010| 
% C++ Signature: BOOL ILE2010::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E2010 * const ModuleDescription)

%SAVE_MODULE_DESCRIPTIONDefinition = addMethod(ILE2010Definition, ...
%    "BOOL ILE2010::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E2010 * const ModuleDescription)", ...
%    "MATLABName", "SAVE_MODULE_DESCRIPTION", ...
%    "Description", "SAVE_MODULE_DESCRIPTION Method of C++ class ILE2010."); % Modify help description values as needed.
%defineArgument(SAVE_MODULE_DESCRIPTIONDefinition, "ModuleDescription", "clib.MyCppLib.MODULE_DESCRIPTION_E2010", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E2010", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E2010"
%defineOutput(SAVE_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
%validate(SAVE_MODULE_DESCRIPTIONDefinition);

%% C++ enumeration |CYCLIC_AUTO_SCAN_TYPES_E310| with MATLAB name |clib.MyCppLib.CYCLIC_AUTO_SCAN_TYPES_E310| 
addEnumeration(libDef, "CYCLIC_AUTO_SCAN_TYPES_E310", "int32",...
    [...
      "NO_CYCLIC_AUTOSCAN_E310",...  % 0
      "CYCLIC_PILA_AUTO_SCAN_E310",...  % 1
      "CYCLIC_TRIANGLE_AUTO_SCAN_E310",...  % 2
      "INVALID_CYCLIC_AUTOSCAN_TYPE_E310",...  % 3
    ],...
    "MATLABName", "clib.MyCppLib.CYCLIC_AUTO_SCAN_TYPES_E310", ...
    "Description", "clib.MyCppLib.CYCLIC_AUTO_SCAN_TYPES_E310    Representation of C++ enumeration CYCLIC_AUTO_SCAN_TYPES_E310."); % Modify help description values as needed.

%% C++ enumeration |INCREMENT_INTERVAL_TYPES_E310| with MATLAB name |clib.MyCppLib.INCREMENT_INTERVAL_TYPES_E310| 
addEnumeration(libDef, "INCREMENT_INTERVAL_TYPES_E310", "int32",...
    [...
      "WAVEFORM_CYCLE_INCREMENT_INTERVAL_E310",...  % 0
      "CLOCK_PERIOD_INCREMENT_INTERVAL_E310",...  % 1
      "INVALID_INCREMENT_INTERVAL_TYPE_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.INCREMENT_INTERVAL_TYPES_E310", ...
    "Description", "clib.MyCppLib.INCREMENT_INTERVAL_TYPES_E310    Representation of C++ enumeration INCREMENT_INTERVAL_TYPES_E310."); % Modify help description values as needed.

%% C++ enumeration |INCREMENT_INTERVAL_MULTIPLIERS_INDEXES_E310| with MATLAB name |clib.MyCppLib.INCREMENT_INTERVAL_MULTIPLIERS_INDEXES_E310| 
addEnumeration(libDef, "INCREMENT_INTERVAL_MULTIPLIERS_INDEXES_E310", "int32",...
    [...
      "INCREMENT_INTERVAL_MULTIPLIERS_001_E310",...  % 0
      "INCREMENT_INTERVAL_MULTIPLIERS_005_E310",...  % 1
      "INCREMENT_INTERVAL_MULTIPLIERS_100_E310",...  % 2
      "INCREMENT_INTERVAL_MULTIPLIERS_500_E310",...  % 3
      "INVALID_INCREMENT_INTERVAL_MULTIPLIER_E310",...  % 4
    ],...
    "MATLABName", "clib.MyCppLib.INCREMENT_INTERVAL_MULTIPLIERS_INDEXES_E310", ...
    "Description", "clib.MyCppLib.INCREMENT_INTERVAL_MULTIPLIERS_INDEXES_E310    Representation of C++ enumeration INCREMENT_INTERVAL_MULTIPLIERS_INDEXES_E310."); % Modify help description values as needed.

%% C++ enumeration |MASTER_CLOCK_SOURCES_E310| with MATLAB name |clib.MyCppLib.MASTER_CLOCK_SOURCES_E310| 
addEnumeration(libDef, "MASTER_CLOCK_SOURCES_E310", "int32",...
    [...
      "INTERNAL_MASTER_CLOCK_E310",...  % 0
      "EXTERNAL_MASTER_CLOCK_E310",...  % 1
      "INVALID_MASTER_CLOCK_SOURCE_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.MASTER_CLOCK_SOURCES_E310", ...
    "Description", "clib.MyCppLib.MASTER_CLOCK_SOURCES_E310    Representation of C++ enumeration MASTER_CLOCK_SOURCES_E310."); % Modify help description values as needed.

%% C++ enumeration |INCREMENT_TYPES_E310| with MATLAB name |clib.MyCppLib.INCREMENT_TYPES_E310| 
addEnumeration(libDef, "INCREMENT_TYPES_E310", "int32",...
    [...
      "AUTO_INCREMENT_E310",...  % 0
      "CTRL_LINE_INCREMENT_E310",...  % 1
      "INVALID_INCREMENT_TYPE_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.INCREMENT_TYPES_E310", ...
    "Description", "clib.MyCppLib.INCREMENT_TYPES_E310    Representation of C++ enumeration INCREMENT_TYPES_E310."); % Modify help description values as needed.

%% C++ enumeration |CTRL_LINE_TYPES_E310| with MATLAB name |clib.MyCppLib.CTRL_LINE_TYPES_E310| 
addEnumeration(libDef, "CTRL_LINE_TYPES_E310", "int32",...
    [...
      "INTERNAL_CTRL_LINE_E310",...  % 0
      "EXTERNAL_CTRL_LINE_E310",...  % 1
      "INVALID_CTRL_LINE_TYPE_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.CTRL_LINE_TYPES_E310", ...
    "Description", "clib.MyCppLib.CTRL_LINE_TYPES_E310    Representation of C++ enumeration CTRL_LINE_TYPES_E310."); % Modify help description values as needed.

%% C++ enumeration |INTERRUPT_LINE_TYPES_E310| with MATLAB name |clib.MyCppLib.INTERRUPT_LINE_TYPES_E310| 
addEnumeration(libDef, "INTERRUPT_LINE_TYPES_E310", "int32",...
    [...
      "INTERNAL_INTERRUPT_LINE_E310",...  % 0
      "EXTERNAL_INTERRUPT_LINE_E310",...  % 1
      "INVALID_INTERRUPT_LINE_TYPE_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.INTERRUPT_LINE_TYPES_E310", ...
    "Description", "clib.MyCppLib.INTERRUPT_LINE_TYPES_E310    Representation of C++ enumeration INTERRUPT_LINE_TYPES_E310."); % Modify help description values as needed.

%% C++ enumeration |SYNCOUT_TYPES_E310| with MATLAB name |clib.MyCppLib.SYNCOUT_TYPES_E310| 
addEnumeration(libDef, "SYNCOUT_TYPES_E310", "int32",...
    [...
      "SYNCOUT_ON_EACH_INCREMENT_E310",...  % 0
      "SYNCOUT_AT_END_OF_SCAN_E310",...  % 1
      "INVALID_SYNCOUT_TYPES_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.SYNCOUT_TYPES_E310", ...
    "Description", "clib.MyCppLib.SYNCOUT_TYPES_E310    Representation of C++ enumeration SYNCOUT_TYPES_E310."); % Modify help description values as needed.

%% C++ enumeration |ANALOG_OUTPUT_TYPES_E310| with MATLAB name |clib.MyCppLib.ANALOG_OUTPUT_TYPES_E310| 
addEnumeration(libDef, "ANALOG_OUTPUT_TYPES_E310", "int32",...
    [...
      "TRIANGULAR_ANALOG_OUTPUT_E310",...  % 0
      "SINUSOIDAL_ANALOG_OUTPUT_E310",...  % 1
      "INVALID_ANALOG_OUTPUT_TYPE_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.ANALOG_OUTPUT_TYPES_E310", ...
    "Description", "clib.MyCppLib.ANALOG_OUTPUT_TYPES_E310    Representation of C++ enumeration ANALOG_OUTPUT_TYPES_E310."); % Modify help description values as needed.

%% C++ enumeration |ANALOG_OUTPUT_GAINS_INDEXES_E310| with MATLAB name |clib.MyCppLib.ANALOG_OUTPUT_GAINS_INDEXES_E310| 
addEnumeration(libDef, "ANALOG_OUTPUT_GAINS_INDEXES_E310", "int32",...
    [...
      "ANALOG_OUTPUT_GAIN_PLUS_10_DB_E310",...  % 0
      "ANALOG_OUTPUT_GAIN_PLUS_06_DB_E310",...  % 1
      "ANALOG_OUTPUT_GAIN_PLUS_04_DB_E310",...  % 2
      "ANALOG_OUTPUT_GAIN_PLUS_03_DB_E310",...  % 3
      "ANALOG_OUTPUT_GAIN_00_DB_E310",...  % 4
      "ANALOG_OUTPUT_GAIN_MINUS_02_DB_E310",...  % 5
      "ANALOG_OUTPUT_GAIN_MINUS_03_DB_E310",...  % 6
      "ANALOG_OUTPUT_GAIN_MINUS_06_DB_E310",...  % 7
      "ANALOG_OUTPUT_GAIN_MINUS_09_DB_E310",...  % 8
      "ANALOG_OUTPUT_GAIN_MINUS_12_DB_E310",...  % 9
      "ANALOG_OUTPUT_GAIN_MINUS_14_DB_E310",...  % 10
      "ANALOG_OUTPUT_GAIN_MINUS_18_DB_E310",...  % 11
      "ANALOG_OUTPUT_GAIN_MINUS_21_DB_E310",...  % 12
      "ANALOG_OUTPUT_GAIN_MINUS_24_DB_E310",...  % 13
      "INVALID_ANALOG_OUTPUT_GAINS_INDEX_E310",...  % 14
      "ANALOG_OUTPUT_GAINS_QUANTITY_E310",...  % 14
    ],...
    "MATLABName", "clib.MyCppLib.ANALOG_OUTPUT_GAINS_INDEXES_E310", ...
    "Description", "clib.MyCppLib.ANALOG_OUTPUT_GAINS_INDEXES_E310    Representation of C++ enumeration ANALOG_OUTPUT_GAINS_INDEXES_E310."); % Modify help description values as needed.

%% C++ enumeration |OUTPUT_10_OHM_OFFSET_SOURCES_E310| with MATLAB name |clib.MyCppLib.OUTPUT_10_OHM_OFFSET_SOURCES_E310| 
addEnumeration(libDef, "OUTPUT_10_OHM_OFFSET_SOURCES_E310", "int32",...
    [...
      "INTERNAL_OUTPUT_10_OHM_OFFSET_E310",...  % 0
      "EXTERNAL_OUTPUT_10_OHM_OFFSET_E310",...  % 1
      "INVALID_OUTPUT_10_OHM_OFFSET_SOURCE_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.OUTPUT_10_OHM_OFFSET_SOURCES_E310", ...
    "Description", "clib.MyCppLib.OUTPUT_10_OHM_OFFSET_SOURCES_E310    Representation of C++ enumeration OUTPUT_10_OHM_OFFSET_SOURCES_E310."); % Modify help description values as needed.

%% C++ enumeration |FM_MODES_E310| with MATLAB name |clib.MyCppLib.FM_MODES_E310| 
addEnumeration(libDef, "FM_MODES_E310", "int32",...
    [...
      "PERIOD_MODE_FM_E310",...  % 0
      "GATE_MODE_FM_E310",...  % 1
      "CAPTURE_MODE_FM_E310",...  % 2
      "INVALID_FM_MODE_E310",...  % 3
    ],...
    "MATLABName", "clib.MyCppLib.FM_MODES_E310", ...
    "Description", "clib.MyCppLib.FM_MODES_E310    Representation of C++ enumeration FM_MODES_E310."); % Modify help description values as needed.

%% C++ enumeration |INPUT_DIVIDER_FM_E310| with MATLAB name |clib.MyCppLib.INPUT_DIVIDER_FM_E310| 
addEnumeration(libDef, "INPUT_DIVIDER_FM_E310", "int32",...
    [...
      "INPUT_DIVIDER_8_FM_E310",...  % 0
      "INPUT_DIVIDER_1_FM_E310",...  % 1
      "INVALID_INPUT_DIVIDER_FM_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.INPUT_DIVIDER_FM_E310", ...
    "Description", "clib.MyCppLib.INPUT_DIVIDER_FM_E310    Representation of C++ enumeration INPUT_DIVIDER_FM_E310."); % Modify help description values as needed.

%% C++ enumeration |BASE_CLOCK_DIV_INDEXES_FM_E310| with MATLAB name |clib.MyCppLib.BASE_CLOCK_DIV_INDEXES_FM_E310| 
addEnumeration(libDef, "BASE_CLOCK_DIV_INDEXES_FM_E310", "int32",...
    [...
      "BASE_CLOCK_DIV_01_INDEX_FM_E310",...  % 0
      "BASE_CLOCK_DIV_02_INDEX_FM_E310",...  % 1
      "BASE_CLOCK_DIV_04_INDEX_FM_E310",...  % 2
      "BASE_CLOCK_DIV_08_INDEX_FM_E310",...  % 3
      "BASE_CLOCK_DIV_16_INDEX_FM_E310",...  % 4
      "BASE_CLOCK_DIV_32_INDEX_FM_E310",...  % 5
      "BASE_CLOCK_DIV_64_INDEX_FM_E310",...  % 6
      "INVALID_BASE_CLOCK_DIV_INDEX_FM_E310",...  % 7
    ],...
    "MATLABName", "clib.MyCppLib.BASE_CLOCK_DIV_INDEXES_FM_E310", ...
    "Description", "clib.MyCppLib.BASE_CLOCK_DIV_INDEXES_FM_E310    Representation of C++ enumeration BASE_CLOCK_DIV_INDEXES_FM_E310."); % Modify help description values as needed.

%% C++ enumeration |ADC_START_SOURCES_E310| with MATLAB name |clib.MyCppLib.ADC_START_SOURCES_E310| 
addEnumeration(libDef, "ADC_START_SOURCES_E310", "int32",...
    [...
      "INTERNAL_ADC_START_E310",...  % 0
      "EXTERNAL_ADC_START_E310",...  % 1
      "INVALID_ADC_START_SOURCES_E310",...  % 2
    ],...
    "MATLABName", "clib.MyCppLib.ADC_START_SOURCES_E310", ...
    "Description", "clib.MyCppLib.ADC_START_SOURCES_E310    Representation of C++ enumeration ADC_START_SOURCES_E310."); % Modify help description values as needed.

%% C++ enumeration |ADC_CHANNEL_BIT_NUMBERS_E310| with MATLAB name |clib.MyCppLib.ADC_CHANNEL_BIT_NUMBERS_E310| 
addEnumeration(libDef, "ADC_CHANNEL_BIT_NUMBERS_E310", "int32",...
    [...
      "ADC_CHANNEL_1_E310",...  % 0
      "ADC_CHANNEL_2_E310",...  % 1
      "ADC_CHANNEL_3_E310",...  % 2
      "ADC_CHANNEL_4_E310",...  % 3
      "INVALID_ADC_CHANNEL_BIT_NUMBER_E310",...  % 4
      "ADC_CHANNEL_QUANTITY_E310",...  % 4
    ],...
    "MATLABName", "clib.MyCppLib.ADC_CHANNEL_BIT_NUMBERS_E310", ...
    "Description", "clib.MyCppLib.ADC_CHANNEL_BIT_NUMBERS_E310    Representation of C++ enumeration ADC_CHANNEL_BIT_NUMBERS_E310."); % Modify help description values as needed.

%% C++ class |MODULE_DESCRIPTION_E310| with MATLAB name |clib.MyCppLib.MODULE_DESCRIPTION_E310| 
MODULE_DESCRIPTION_E310Definition = addClass(libDef, "MODULE_DESCRIPTION_E310", "MATLABName", "clib.MyCppLib.MODULE_DESCRIPTION_E310", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E310    Representation of C++ class MODULE_DESCRIPTION_E310."); % Modify help description values as needed.

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E310| 
% C++ Signature: MODULE_DESCRIPTION_E310::MODULE_DESCRIPTION_E310(MODULE_DESCRIPTION_E310 const & input1)

MODULE_DESCRIPTION_E310Constructor1Definition = addConstructor(MODULE_DESCRIPTION_E310Definition, ...
    "MODULE_DESCRIPTION_E310::MODULE_DESCRIPTION_E310(MODULE_DESCRIPTION_E310 const & input1)", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E310 Constructor of C++ class MODULE_DESCRIPTION_E310."); % Modify help description values as needed.
defineArgument(MODULE_DESCRIPTION_E310Constructor1Definition, "input1", "clib.MyCppLib.MODULE_DESCRIPTION_E310", "input");
validate(MODULE_DESCRIPTION_E310Constructor1Definition);

%% C++ class constructor for C++ class |MODULE_DESCRIPTION_E310| 
% C++ Signature: MODULE_DESCRIPTION_E310::MODULE_DESCRIPTION_E310()

MODULE_DESCRIPTION_E310Constructor2Definition = addConstructor(MODULE_DESCRIPTION_E310Definition, ...
    "MODULE_DESCRIPTION_E310::MODULE_DESCRIPTION_E310()", ...
    "Description", "clib.MyCppLib.MODULE_DESCRIPTION_E310 Constructor of C++ class MODULE_DESCRIPTION_E310."); % Modify help description values as needed.
validate(MODULE_DESCRIPTION_E310Constructor2Definition);

%% C++ class public data member |Module| for C++ class |MODULE_DESCRIPTION_E310| 
% C++ Signature: MODULE_INFO_LUSBAPI MODULE_DESCRIPTION_E310::Module

addProperty(MODULE_DESCRIPTION_E310Definition, "Module", "clib.MyCppLib.MODULE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.MODULE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E310."); % Modify help description values as needed.

%% C++ class public data member |Interface| for C++ class |MODULE_DESCRIPTION_E310| 
% C++ Signature: INTERFACE_INFO_LUSBAPI MODULE_DESCRIPTION_E310::Interface

addProperty(MODULE_DESCRIPTION_E310Definition, "Interface", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.INTERFACE_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E310."); % Modify help description values as needed.

%% C++ class public data member |Mcu| for C++ class |MODULE_DESCRIPTION_E310| 
% C++ Signature: MCU_INFO_LUSBAPI<MCU_VERSION_INFO_LUSBAPI> MODULE_DESCRIPTION_E310::Mcu

addProperty(MODULE_DESCRIPTION_E310Definition, "Mcu", "clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_", ...
    "Description", "clib.MyCppLib.MCU_INFO_LUSBAPI_MCU_VERSION_INFO_LUSBAPI_    Data member of C++ class MODULE_DESCRIPTION_E310."); % Modify help description values as needed.

%% C++ class public data member |Adc| for C++ class |MODULE_DESCRIPTION_E310| 
% C++ Signature: ADC_INFO_LUSBAPI MODULE_DESCRIPTION_E310::Adc

addProperty(MODULE_DESCRIPTION_E310Definition, "Adc", "clib.MyCppLib.ADC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.ADC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E310."); % Modify help description values as needed.

%% C++ class public data member |Dac| for C++ class |MODULE_DESCRIPTION_E310| 
% C++ Signature: DAC_INFO_LUSBAPI MODULE_DESCRIPTION_E310::Dac

addProperty(MODULE_DESCRIPTION_E310Definition, "Dac", "clib.MyCppLib.DAC_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DAC_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E310."); % Modify help description values as needed.

%% C++ class public data member |DigitalIo| for C++ class |MODULE_DESCRIPTION_E310| 
% C++ Signature: DIGITAL_IO_INFO_LUSBAPI MODULE_DESCRIPTION_E310::DigitalIo

addProperty(MODULE_DESCRIPTION_E310Definition, "DigitalIo", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI", ...
    "Description", "clib.MyCppLib.DIGITAL_IO_INFO_LUSBAPI    Data member of C++ class MODULE_DESCRIPTION_E310."); % Modify help description values as needed.

%% C++ class |USER_FLASH_E310| with MATLAB name |clib.MyCppLib.USER_FLASH_E310| 
USER_FLASH_E310Definition = addClass(libDef, "USER_FLASH_E310", "MATLABName", "clib.MyCppLib.USER_FLASH_E310", ...
    "Description", "clib.MyCppLib.USER_FLASH_E310    Representation of C++ class USER_FLASH_E310."); % Modify help description values as needed.

%% C++ class constructor for C++ class |USER_FLASH_E310| 
% C++ Signature: USER_FLASH_E310::USER_FLASH_E310(USER_FLASH_E310 const & input1)

USER_FLASH_E310Constructor1Definition = addConstructor(USER_FLASH_E310Definition, ...
    "USER_FLASH_E310::USER_FLASH_E310(USER_FLASH_E310 const & input1)", ...
    "Description", "clib.MyCppLib.USER_FLASH_E310 Constructor of C++ class USER_FLASH_E310."); % Modify help description values as needed.
defineArgument(USER_FLASH_E310Constructor1Definition, "input1", "clib.MyCppLib.USER_FLASH_E310", "input");
validate(USER_FLASH_E310Constructor1Definition);

%% C++ class constructor for C++ class |USER_FLASH_E310| 
% C++ Signature: USER_FLASH_E310::USER_FLASH_E310()

USER_FLASH_E310Constructor2Definition = addConstructor(USER_FLASH_E310Definition, ...
    "USER_FLASH_E310::USER_FLASH_E310()", ...
    "Description", "clib.MyCppLib.USER_FLASH_E310 Constructor of C++ class USER_FLASH_E310."); % Modify help description values as needed.
validate(USER_FLASH_E310Constructor2Definition);

%% C++ class public data member |Buffer| for C++ class |USER_FLASH_E310| 
% C++ Signature: BYTE [512] USER_FLASH_E310::Buffer

addProperty(USER_FLASH_E310Definition, "Buffer", "clib.array.MyCppLib.UnsignedChar", [512], ... % <MLTYPE> can be "clib.array.MyCppLib.UnsignedChar", or "uint8"
    "Description", "clib.array.MyCppLib.UnsignedChar    Data member of C++ class USER_FLASH_E310."); % Modify help description values as needed.

%% C++ class |INCREMENT_INTRERVAL_PARS_E310| with MATLAB name |clib.MyCppLib.INCREMENT_INTRERVAL_PARS_E310| 
INCREMENT_INTRERVAL_PARS_E310Definition = addClass(libDef, "INCREMENT_INTRERVAL_PARS_E310", "MATLABName", "clib.MyCppLib.INCREMENT_INTRERVAL_PARS_E310", ...
    "Description", "clib.MyCppLib.INCREMENT_INTRERVAL_PARS_E310    Representation of C++ class INCREMENT_INTRERVAL_PARS_E310."); % Modify help description values as needed.

%% C++ class constructor for C++ class |INCREMENT_INTRERVAL_PARS_E310| 
% C++ Signature: INCREMENT_INTRERVAL_PARS_E310::INCREMENT_INTRERVAL_PARS_E310(INCREMENT_INTRERVAL_PARS_E310 const & input1)

INCREMENT_INTRERVAL_PARS_E310Constructor1Definition = addConstructor(INCREMENT_INTRERVAL_PARS_E310Definition, ...
    "INCREMENT_INTRERVAL_PARS_E310::INCREMENT_INTRERVAL_PARS_E310(INCREMENT_INTRERVAL_PARS_E310 const & input1)", ...
    "Description", "clib.MyCppLib.INCREMENT_INTRERVAL_PARS_E310 Constructor of C++ class INCREMENT_INTRERVAL_PARS_E310."); % Modify help description values as needed.
defineArgument(INCREMENT_INTRERVAL_PARS_E310Constructor1Definition, "input1", "clib.MyCppLib.INCREMENT_INTRERVAL_PARS_E310", "input");
validate(INCREMENT_INTRERVAL_PARS_E310Constructor1Definition);

%% C++ class constructor for C++ class |INCREMENT_INTRERVAL_PARS_E310| 
% C++ Signature: INCREMENT_INTRERVAL_PARS_E310::INCREMENT_INTRERVAL_PARS_E310()

INCREMENT_INTRERVAL_PARS_E310Constructor2Definition = addConstructor(INCREMENT_INTRERVAL_PARS_E310Definition, ...
    "INCREMENT_INTRERVAL_PARS_E310::INCREMENT_INTRERVAL_PARS_E310()", ...
    "Description", "clib.MyCppLib.INCREMENT_INTRERVAL_PARS_E310 Constructor of C++ class INCREMENT_INTRERVAL_PARS_E310."); % Modify help description values as needed.
validate(INCREMENT_INTRERVAL_PARS_E310Constructor2Definition);

%% C++ class public data member |BaseIntervalType| for C++ class |INCREMENT_INTRERVAL_PARS_E310| 
% C++ Signature: BYTE INCREMENT_INTRERVAL_PARS_E310::BaseIntervalType

addProperty(INCREMENT_INTRERVAL_PARS_E310Definition, "BaseIntervalType", "uint8", ...
    "Description", "uint8    Data member of C++ class INCREMENT_INTRERVAL_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |MultiplierIndex| for C++ class |INCREMENT_INTRERVAL_PARS_E310| 
% C++ Signature: BYTE INCREMENT_INTRERVAL_PARS_E310::MultiplierIndex

addProperty(INCREMENT_INTRERVAL_PARS_E310Definition, "MultiplierIndex", "uint8", ...
    "Description", "uint8    Data member of C++ class INCREMENT_INTRERVAL_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |MultiplierValue| for C++ class |INCREMENT_INTRERVAL_PARS_E310| 
% C++ Signature: double INCREMENT_INTRERVAL_PARS_E310::MultiplierValue

addProperty(INCREMENT_INTRERVAL_PARS_E310Definition, "MultiplierValue", "double", ...
    "Description", "double    Data member of C++ class INCREMENT_INTRERVAL_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |BaseIntervalsNumber| for C++ class |INCREMENT_INTRERVAL_PARS_E310| 
% C++ Signature: WORD INCREMENT_INTRERVAL_PARS_E310::BaseIntervalsNumber

addProperty(INCREMENT_INTRERVAL_PARS_E310Definition, "BaseIntervalsNumber", "uint16", ...
    "Description", "uint16    Data member of C++ class INCREMENT_INTRERVAL_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |Duration| for C++ class |INCREMENT_INTRERVAL_PARS_E310| 
% C++ Signature: double INCREMENT_INTRERVAL_PARS_E310::Duration

addProperty(INCREMENT_INTRERVAL_PARS_E310Definition, "Duration", "double", ...
    "Description", "double    Data member of C++ class INCREMENT_INTRERVAL_PARS_E310."); % Modify help description values as needed.

%% C++ class |ANALOG_OUTPUTS_PARS_E310| with MATLAB name |clib.MyCppLib.ANALOG_OUTPUTS_PARS_E310| 
ANALOG_OUTPUTS_PARS_E310Definition = addClass(libDef, "ANALOG_OUTPUTS_PARS_E310", "MATLABName", "clib.MyCppLib.ANALOG_OUTPUTS_PARS_E310", ...
    "Description", "clib.MyCppLib.ANALOG_OUTPUTS_PARS_E310    Representation of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class constructor for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: ANALOG_OUTPUTS_PARS_E310::ANALOG_OUTPUTS_PARS_E310(ANALOG_OUTPUTS_PARS_E310 const & input1)

ANALOG_OUTPUTS_PARS_E310Constructor1Definition = addConstructor(ANALOG_OUTPUTS_PARS_E310Definition, ...
    "ANALOG_OUTPUTS_PARS_E310::ANALOG_OUTPUTS_PARS_E310(ANALOG_OUTPUTS_PARS_E310 const & input1)", ...
    "Description", "clib.MyCppLib.ANALOG_OUTPUTS_PARS_E310 Constructor of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.
defineArgument(ANALOG_OUTPUTS_PARS_E310Constructor1Definition, "input1", "clib.MyCppLib.ANALOG_OUTPUTS_PARS_E310", "input");
validate(ANALOG_OUTPUTS_PARS_E310Constructor1Definition);

%% C++ class constructor for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: ANALOG_OUTPUTS_PARS_E310::ANALOG_OUTPUTS_PARS_E310()

ANALOG_OUTPUTS_PARS_E310Constructor2Definition = addConstructor(ANALOG_OUTPUTS_PARS_E310Definition, ...
    "ANALOG_OUTPUTS_PARS_E310::ANALOG_OUTPUTS_PARS_E310()", ...
    "Description", "clib.MyCppLib.ANALOG_OUTPUTS_PARS_E310 Constructor of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.
validate(ANALOG_OUTPUTS_PARS_E310Constructor2Definition);

%% C++ class public data member |SignalType| for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: BYTE ANALOG_OUTPUTS_PARS_E310::SignalType

addProperty(ANALOG_OUTPUTS_PARS_E310Definition, "SignalType", "uint8", ...
    "Description", "uint8    Data member of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |GainIndex| for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: BYTE ANALOG_OUTPUTS_PARS_E310::GainIndex

addProperty(ANALOG_OUTPUTS_PARS_E310Definition, "GainIndex", "uint8", ...
    "Description", "uint8    Data member of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |GaindB| for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: double ANALOG_OUTPUTS_PARS_E310::GaindB

addProperty(ANALOG_OUTPUTS_PARS_E310Definition, "GaindB", "double", ...
    "Description", "double    Data member of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |Output10OhmInV| for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: double ANALOG_OUTPUTS_PARS_E310::Output10OhmInV

addProperty(ANALOG_OUTPUTS_PARS_E310Definition, "Output10OhmInV", "double", ...
    "Description", "double    Data member of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |Output10OhmIndB| for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: double ANALOG_OUTPUTS_PARS_E310::Output10OhmIndB

addProperty(ANALOG_OUTPUTS_PARS_E310Definition, "Output10OhmIndB", "double", ...
    "Description", "double    Data member of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |Output10OhmOffset| for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: double ANALOG_OUTPUTS_PARS_E310::Output10OhmOffset

addProperty(ANALOG_OUTPUTS_PARS_E310Definition, "Output10OhmOffset", "double", ...
    "Description", "double    Data member of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |Output10OhmOffsetSource| for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: BYTE ANALOG_OUTPUTS_PARS_E310::Output10OhmOffsetSource

addProperty(ANALOG_OUTPUTS_PARS_E310Definition, "Output10OhmOffsetSource", "uint8", ...
    "Description", "uint8    Data member of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |Output50OhmInV| for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: double ANALOG_OUTPUTS_PARS_E310::Output50OhmInV

addProperty(ANALOG_OUTPUTS_PARS_E310Definition, "Output50OhmInV", "double", ...
    "Description", "double    Data member of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |Output50OhmIndB| for C++ class |ANALOG_OUTPUTS_PARS_E310| 
% C++ Signature: double ANALOG_OUTPUTS_PARS_E310::Output50OhmIndB

addProperty(ANALOG_OUTPUTS_PARS_E310Definition, "Output50OhmIndB", "double", ...
    "Description", "double    Data member of C++ class ANALOG_OUTPUTS_PARS_E310."); % Modify help description values as needed.

%% C++ class |GENERATOR_PARS_E310| with MATLAB name |clib.MyCppLib.GENERATOR_PARS_E310| 
GENERATOR_PARS_E310Definition = addClass(libDef, "GENERATOR_PARS_E310", "MATLABName", "clib.MyCppLib.GENERATOR_PARS_E310", ...
    "Description", "clib.MyCppLib.GENERATOR_PARS_E310    Representation of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class constructor for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: GENERATOR_PARS_E310::GENERATOR_PARS_E310(GENERATOR_PARS_E310 const & input1)

GENERATOR_PARS_E310Constructor1Definition = addConstructor(GENERATOR_PARS_E310Definition, ...
    "GENERATOR_PARS_E310::GENERATOR_PARS_E310(GENERATOR_PARS_E310 const & input1)", ...
    "Description", "clib.MyCppLib.GENERATOR_PARS_E310 Constructor of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.
defineArgument(GENERATOR_PARS_E310Constructor1Definition, "input1", "clib.MyCppLib.GENERATOR_PARS_E310", "input");
validate(GENERATOR_PARS_E310Constructor1Definition);

%% C++ class constructor for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: GENERATOR_PARS_E310::GENERATOR_PARS_E310()

GENERATOR_PARS_E310Constructor2Definition = addConstructor(GENERATOR_PARS_E310Definition, ...
    "GENERATOR_PARS_E310::GENERATOR_PARS_E310()", ...
    "Description", "clib.MyCppLib.GENERATOR_PARS_E310 Constructor of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.
validate(GENERATOR_PARS_E310Constructor2Definition);

%% C++ class public data member |GeneratorEna| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: BOOL GENERATOR_PARS_E310::GeneratorEna

addProperty(GENERATOR_PARS_E310Definition, "GeneratorEna", "int32", ...
    "Description", "int32    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |StartFrequency| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: double GENERATOR_PARS_E310::StartFrequency

addProperty(GENERATOR_PARS_E310Definition, "StartFrequency", "double", ...
    "Description", "double    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |FinalFrequency| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: double GENERATOR_PARS_E310::FinalFrequency

addProperty(GENERATOR_PARS_E310Definition, "FinalFrequency", "double", ...
    "Description", "double    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |FrequencyIncrements| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: double GENERATOR_PARS_E310::FrequencyIncrements

addProperty(GENERATOR_PARS_E310Definition, "FrequencyIncrements", "double", ...
    "Description", "double    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |NumberOfIncrements| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: WORD GENERATOR_PARS_E310::NumberOfIncrements

addProperty(GENERATOR_PARS_E310Definition, "NumberOfIncrements", "uint16", ...
    "Description", "uint16    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |IncrementIntervalPars| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: INCREMENT_INTRERVAL_PARS_E310 GENERATOR_PARS_E310::IncrementIntervalPars

addProperty(GENERATOR_PARS_E310Definition, "IncrementIntervalPars", "clib.MyCppLib.INCREMENT_INTRERVAL_PARS_E310", ...
    "Description", "clib.MyCppLib.INCREMENT_INTRERVAL_PARS_E310    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |MasterClock| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: double GENERATOR_PARS_E310::MasterClock

addProperty(GENERATOR_PARS_E310Definition, "MasterClock", "double", ...
    "Description", "double    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |MasterClockSource| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: BYTE GENERATOR_PARS_E310::MasterClockSource

addProperty(GENERATOR_PARS_E310Definition, "MasterClockSource", "uint8", ...
    "Description", "uint8    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |CyclicAutoScanType| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: BYTE GENERATOR_PARS_E310::CyclicAutoScanType

addProperty(GENERATOR_PARS_E310Definition, "CyclicAutoScanType", "uint8", ...
    "Description", "uint8    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |IncrementType| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: BYTE GENERATOR_PARS_E310::IncrementType

addProperty(GENERATOR_PARS_E310Definition, "IncrementType", "uint8", ...
    "Description", "uint8    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |CtrlLineType| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: BYTE GENERATOR_PARS_E310::CtrlLineType

addProperty(GENERATOR_PARS_E310Definition, "CtrlLineType", "uint8", ...
    "Description", "uint8    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |InterrupLineType| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: BYTE GENERATOR_PARS_E310::InterrupLineType

addProperty(GENERATOR_PARS_E310Definition, "InterrupLineType", "uint8", ...
    "Description", "uint8    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |SquareWaveOutputEna| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: BOOL GENERATOR_PARS_E310::SquareWaveOutputEna

addProperty(GENERATOR_PARS_E310Definition, "SquareWaveOutputEna", "int32", ...
    "Description", "int32    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |SynchroOutEna| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: BOOL GENERATOR_PARS_E310::SynchroOutEna

addProperty(GENERATOR_PARS_E310Definition, "SynchroOutEna", "int32", ...
    "Description", "int32    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |SynchroOutType| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: BYTE GENERATOR_PARS_E310::SynchroOutType

addProperty(GENERATOR_PARS_E310Definition, "SynchroOutType", "uint8", ...
    "Description", "uint8    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |AnalogOutputsPars| for C++ class |GENERATOR_PARS_E310| 
% C++ Signature: ANALOG_OUTPUTS_PARS_E310 GENERATOR_PARS_E310::AnalogOutputsPars

addProperty(GENERATOR_PARS_E310Definition, "AnalogOutputsPars", "clib.MyCppLib.ANALOG_OUTPUTS_PARS_E310", ...
    "Description", "clib.MyCppLib.ANALOG_OUTPUTS_PARS_E310    Data member of C++ class GENERATOR_PARS_E310."); % Modify help description values as needed.

%% C++ class |FM_PARS_E310| with MATLAB name |clib.MyCppLib.FM_PARS_E310| 
FM_PARS_E310Definition = addClass(libDef, "FM_PARS_E310", "MATLABName", "clib.MyCppLib.FM_PARS_E310", ...
    "Description", "clib.MyCppLib.FM_PARS_E310    Representation of C++ class FM_PARS_E310."); % Modify help description values as needed.

%% C++ class constructor for C++ class |FM_PARS_E310| 
% C++ Signature: FM_PARS_E310::FM_PARS_E310(FM_PARS_E310 const & input1)

FM_PARS_E310Constructor1Definition = addConstructor(FM_PARS_E310Definition, ...
    "FM_PARS_E310::FM_PARS_E310(FM_PARS_E310 const & input1)", ...
    "Description", "clib.MyCppLib.FM_PARS_E310 Constructor of C++ class FM_PARS_E310."); % Modify help description values as needed.
defineArgument(FM_PARS_E310Constructor1Definition, "input1", "clib.MyCppLib.FM_PARS_E310", "input");
validate(FM_PARS_E310Constructor1Definition);

%% C++ class constructor for C++ class |FM_PARS_E310| 
% C++ Signature: FM_PARS_E310::FM_PARS_E310()

FM_PARS_E310Constructor2Definition = addConstructor(FM_PARS_E310Definition, ...
    "FM_PARS_E310::FM_PARS_E310()", ...
    "Description", "clib.MyCppLib.FM_PARS_E310 Constructor of C++ class FM_PARS_E310."); % Modify help description values as needed.
validate(FM_PARS_E310Constructor2Definition);

%% C++ class public data member |FmEna| for C++ class |FM_PARS_E310| 
% C++ Signature: BOOL FM_PARS_E310::FmEna

addProperty(FM_PARS_E310Definition, "FmEna", "int32", ...
    "Description", "int32    Data member of C++ class FM_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |Mode| for C++ class |FM_PARS_E310| 
% C++ Signature: BYTE FM_PARS_E310::Mode

addProperty(FM_PARS_E310Definition, "Mode", "uint8", ...
    "Description", "uint8    Data member of C++ class FM_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |InputDivider| for C++ class |FM_PARS_E310| 
% C++ Signature: BYTE FM_PARS_E310::InputDivider

addProperty(FM_PARS_E310Definition, "InputDivider", "uint8", ...
    "Description", "uint8    Data member of C++ class FM_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |BaseClockRateDivIndex| for C++ class |FM_PARS_E310| 
% C++ Signature: BYTE FM_PARS_E310::BaseClockRateDivIndex

addProperty(FM_PARS_E310Definition, "BaseClockRateDivIndex", "uint8", ...
    "Description", "uint8    Data member of C++ class FM_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |ClockRate| for C++ class |FM_PARS_E310| 
% C++ Signature: DWORD FM_PARS_E310::ClockRate

addProperty(FM_PARS_E310Definition, "ClockRate", "uint32", ...
    "Description", "uint32    Data member of C++ class FM_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |BaseClockRate| for C++ class |FM_PARS_E310| 
% C++ Signature: DWORD FM_PARS_E310::BaseClockRate

addProperty(FM_PARS_E310Definition, "BaseClockRate", "uint32", ...
    "Description", "uint32    Data member of C++ class FM_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |Offset| for C++ class |FM_PARS_E310| 
% C++ Signature: double FM_PARS_E310::Offset

addProperty(FM_PARS_E310Definition, "Offset", "double", ...
    "Description", "double    Data member of C++ class FM_PARS_E310."); % Modify help description values as needed.

%% C++ class |FM_SAMPLE_E310| with MATLAB name |clib.MyCppLib.FM_SAMPLE_E310| 
FM_SAMPLE_E310Definition = addClass(libDef, "FM_SAMPLE_E310", "MATLABName", "clib.MyCppLib.FM_SAMPLE_E310", ...
    "Description", "clib.MyCppLib.FM_SAMPLE_E310    Representation of C++ class FM_SAMPLE_E310."); % Modify help description values as needed.

%% C++ class constructor for C++ class |FM_SAMPLE_E310| 
% C++ Signature: FM_SAMPLE_E310::FM_SAMPLE_E310(FM_SAMPLE_E310 const & input1)

FM_SAMPLE_E310Constructor1Definition = addConstructor(FM_SAMPLE_E310Definition, ...
    "FM_SAMPLE_E310::FM_SAMPLE_E310(FM_SAMPLE_E310 const & input1)", ...
    "Description", "clib.MyCppLib.FM_SAMPLE_E310 Constructor of C++ class FM_SAMPLE_E310."); % Modify help description values as needed.
defineArgument(FM_SAMPLE_E310Constructor1Definition, "input1", "clib.MyCppLib.FM_SAMPLE_E310", "input");
validate(FM_SAMPLE_E310Constructor1Definition);

%% C++ class constructor for C++ class |FM_SAMPLE_E310| 
% C++ Signature: FM_SAMPLE_E310::FM_SAMPLE_E310()

FM_SAMPLE_E310Constructor2Definition = addConstructor(FM_SAMPLE_E310Definition, ...
    "FM_SAMPLE_E310::FM_SAMPLE_E310()", ...
    "Description", "clib.MyCppLib.FM_SAMPLE_E310 Constructor of C++ class FM_SAMPLE_E310."); % Modify help description values as needed.
validate(FM_SAMPLE_E310Constructor2Definition);

%% C++ class public data member |IsActual| for C++ class |FM_SAMPLE_E310| 
% C++ Signature: BOOL FM_SAMPLE_E310::IsActual

addProperty(FM_SAMPLE_E310Definition, "IsActual", "int32", ...
    "Description", "int32    Data member of C++ class FM_SAMPLE_E310."); % Modify help description values as needed.

%% C++ class public data member |Frequency| for C++ class |FM_SAMPLE_E310| 
% C++ Signature: double FM_SAMPLE_E310::Frequency

addProperty(FM_SAMPLE_E310Definition, "Frequency", "double", ...
    "Description", "double    Data member of C++ class FM_SAMPLE_E310."); % Modify help description values as needed.

%% C++ class public data member |Period| for C++ class |FM_SAMPLE_E310| 
% C++ Signature: double FM_SAMPLE_E310::Period

addProperty(FM_SAMPLE_E310Definition, "Period", "double", ...
    "Description", "double    Data member of C++ class FM_SAMPLE_E310."); % Modify help description values as needed.

%% C++ class public data member |DutyCycle| for C++ class |FM_SAMPLE_E310| 
% C++ Signature: double FM_SAMPLE_E310::DutyCycle

addProperty(FM_SAMPLE_E310Definition, "DutyCycle", "double", ...
    "Description", "double    Data member of C++ class FM_SAMPLE_E310."); % Modify help description values as needed.

%% C++ class |ADC_PARS_E310| with MATLAB name |clib.MyCppLib.ADC_PARS_E310| 
ADC_PARS_E310Definition = addClass(libDef, "ADC_PARS_E310", "MATLABName", "clib.MyCppLib.ADC_PARS_E310", ...
    "Description", "clib.MyCppLib.ADC_PARS_E310    Representation of C++ class ADC_PARS_E310."); % Modify help description values as needed.

%% C++ class constructor for C++ class |ADC_PARS_E310| 
% C++ Signature: ADC_PARS_E310::ADC_PARS_E310(ADC_PARS_E310 const & input1)

ADC_PARS_E310Constructor1Definition = addConstructor(ADC_PARS_E310Definition, ...
    "ADC_PARS_E310::ADC_PARS_E310(ADC_PARS_E310 const & input1)", ...
    "Description", "clib.MyCppLib.ADC_PARS_E310 Constructor of C++ class ADC_PARS_E310."); % Modify help description values as needed.
defineArgument(ADC_PARS_E310Constructor1Definition, "input1", "clib.MyCppLib.ADC_PARS_E310", "input");
validate(ADC_PARS_E310Constructor1Definition);

%% C++ class constructor for C++ class |ADC_PARS_E310| 
% C++ Signature: ADC_PARS_E310::ADC_PARS_E310()

ADC_PARS_E310Constructor2Definition = addConstructor(ADC_PARS_E310Definition, ...
    "ADC_PARS_E310::ADC_PARS_E310()", ...
    "Description", "clib.MyCppLib.ADC_PARS_E310 Constructor of C++ class ADC_PARS_E310."); % Modify help description values as needed.
validate(ADC_PARS_E310Constructor2Definition);

%% C++ class public data member |AdcStartSource| for C++ class |ADC_PARS_E310| 
% C++ Signature: BYTE ADC_PARS_E310::AdcStartSource

addProperty(ADC_PARS_E310Definition, "AdcStartSource", "uint8", ...
    "Description", "uint8    Data member of C++ class ADC_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |ChannelsMask| for C++ class |ADC_PARS_E310| 
% C++ Signature: BYTE ADC_PARS_E310::ChannelsMask

addProperty(ADC_PARS_E310Definition, "ChannelsMask", "uint8", ...
    "Description", "uint8    Data member of C++ class ADC_PARS_E310."); % Modify help description values as needed.

%% C++ class public data member |InputRange| for C++ class |ADC_PARS_E310| 
% C++ Signature: double ADC_PARS_E310::InputRange

addProperty(ADC_PARS_E310Definition, "InputRange", "double", ...
    "Description", "double    Data member of C++ class ADC_PARS_E310."); % Modify help description values as needed.

%% C++ class |ADC_DATA_E310| with MATLAB name |clib.MyCppLib.ADC_DATA_E310| 
ADC_DATA_E310Definition = addClass(libDef, "ADC_DATA_E310", "MATLABName", "clib.MyCppLib.ADC_DATA_E310", ...
    "Description", "clib.MyCppLib.ADC_DATA_E310    Representation of C++ class ADC_DATA_E310."); % Modify help description values as needed.

%% C++ class constructor for C++ class |ADC_DATA_E310| 
% C++ Signature: ADC_DATA_E310::ADC_DATA_E310(ADC_DATA_E310 const & input1)

ADC_DATA_E310Constructor1Definition = addConstructor(ADC_DATA_E310Definition, ...
    "ADC_DATA_E310::ADC_DATA_E310(ADC_DATA_E310 const & input1)", ...
    "Description", "clib.MyCppLib.ADC_DATA_E310 Constructor of C++ class ADC_DATA_E310."); % Modify help description values as needed.
defineArgument(ADC_DATA_E310Constructor1Definition, "input1", "clib.MyCppLib.ADC_DATA_E310", "input");
validate(ADC_DATA_E310Constructor1Definition);

%% C++ class constructor for C++ class |ADC_DATA_E310| 
% C++ Signature: ADC_DATA_E310::ADC_DATA_E310()

ADC_DATA_E310Constructor2Definition = addConstructor(ADC_DATA_E310Definition, ...
    "ADC_DATA_E310::ADC_DATA_E310()", ...
    "Description", "clib.MyCppLib.ADC_DATA_E310 Constructor of C++ class ADC_DATA_E310."); % Modify help description values as needed.
validate(ADC_DATA_E310Constructor2Definition);

%% C++ class public data member |DataInCode| for C++ class |ADC_DATA_E310| 
% C++ Signature: SHORT [4] ADC_DATA_E310::DataInCode

addProperty(ADC_DATA_E310Definition, "DataInCode", "clib.array.MyCppLib.Short", [4], ... % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
    "Description", "clib.array.MyCppLib.Short    Data member of C++ class ADC_DATA_E310."); % Modify help description values as needed.

%% C++ class public data member |DataInV| for C++ class |ADC_DATA_E310| 
% C++ Signature: double [4] ADC_DATA_E310::DataInV

addProperty(ADC_DATA_E310Definition, "DataInV", "clib.array.MyCppLib.Double", [4], ... % <MLTYPE> can be "clib.array.MyCppLib.Double", or "double"
    "Description", "clib.array.MyCppLib.Double    Data member of C++ class ADC_DATA_E310."); % Modify help description values as needed.

%% C++ class |ILE310| with MATLAB name |clib.MyCppLib.ILE310| 
ILE310Definition = addClass(libDef, "ILE310", "MATLABName", "clib.MyCppLib.ILE310", ...
    "Description", "clib.MyCppLib.ILE310    Representation of C++ class ILE310."); % Modify help description values as needed.

%% C++ class method |GET_GENERATOR_PARS| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::GET_GENERATOR_PARS(GENERATOR_PARS_E310 * const GenPars)

%GET_GENERATOR_PARSDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::GET_GENERATOR_PARS(GENERATOR_PARS_E310 * const GenPars)", ...
%    "MATLABName", "GET_GENERATOR_PARS", ...
%    "Description", "GET_GENERATOR_PARS Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(GET_GENERATOR_PARSDefinition, "GenPars", "clib.MyCppLib.GENERATOR_PARS_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.GENERATOR_PARS_E310", or "clib.array.MyCppLib.GENERATOR_PARS_E310"
%defineOutput(GET_GENERATOR_PARSDefinition, "RetVal", "int32");
%validate(GET_GENERATOR_PARSDefinition);

%% C++ class method |SET_GENERATOR_PARS| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::SET_GENERATOR_PARS(GENERATOR_PARS_E310 * const GenPars)

%SET_GENERATOR_PARSDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::SET_GENERATOR_PARS(GENERATOR_PARS_E310 * const GenPars)", ...
%    "MATLABName", "SET_GENERATOR_PARS", ...
%    "Description", "SET_GENERATOR_PARS Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(SET_GENERATOR_PARSDefinition, "GenPars", "clib.MyCppLib.GENERATOR_PARS_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.GENERATOR_PARS_E310", or "clib.array.MyCppLib.GENERATOR_PARS_E310"
%defineOutput(SET_GENERATOR_PARSDefinition, "RetVal", "int32");
%validate(SET_GENERATOR_PARSDefinition);

%% C++ class method |START_GENERATOR| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::START_GENERATOR()

START_GENERATORDefinition = addMethod(ILE310Definition, ...
    "BOOL ILE310::START_GENERATOR()", ...
    "MATLABName", "START_GENERATOR", ...
    "Description", "START_GENERATOR Method of C++ class ILE310."); % Modify help description values as needed.
defineOutput(START_GENERATORDefinition, "RetVal", "int32");
validate(START_GENERATORDefinition);

%% C++ class method |STOP_GENERATOR| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::STOP_GENERATOR()

STOP_GENERATORDefinition = addMethod(ILE310Definition, ...
    "BOOL ILE310::STOP_GENERATOR()", ...
    "MATLABName", "STOP_GENERATOR", ...
    "Description", "STOP_GENERATOR Method of C++ class ILE310."); % Modify help description values as needed.
defineOutput(STOP_GENERATORDefinition, "RetVal", "int32");
validate(STOP_GENERATORDefinition);

%% C++ class method |GET_FM_PARS| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::GET_FM_PARS(FM_PARS_E310 * const FmPars)

%GET_FM_PARSDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::GET_FM_PARS(FM_PARS_E310 * const FmPars)", ...
%    "MATLABName", "GET_FM_PARS", ...
%    "Description", "GET_FM_PARS Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(GET_FM_PARSDefinition, "FmPars", "clib.MyCppLib.FM_PARS_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.FM_PARS_E310", or "clib.array.MyCppLib.FM_PARS_E310"
%defineOutput(GET_FM_PARSDefinition, "RetVal", "int32");
%validate(GET_FM_PARSDefinition);

%% C++ class method |SET_FM_PARS| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::SET_FM_PARS(FM_PARS_E310 * const FmPars)

%SET_FM_PARSDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::SET_FM_PARS(FM_PARS_E310 * const FmPars)", ...
%    "MATLABName", "SET_FM_PARS", ...
%    "Description", "SET_FM_PARS Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(SET_FM_PARSDefinition, "FmPars", "clib.MyCppLib.FM_PARS_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.FM_PARS_E310", or "clib.array.MyCppLib.FM_PARS_E310"
%defineOutput(SET_FM_PARSDefinition, "RetVal", "int32");
%validate(SET_FM_PARSDefinition);

%% C++ class method |START_FM| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::START_FM()

START_FMDefinition = addMethod(ILE310Definition, ...
    "BOOL ILE310::START_FM()", ...
    "MATLABName", "START_FM", ...
    "Description", "START_FM Method of C++ class ILE310."); % Modify help description values as needed.
defineOutput(START_FMDefinition, "RetVal", "int32");
validate(START_FMDefinition);

%% C++ class method |STOP_FM| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::STOP_FM()

STOP_FMDefinition = addMethod(ILE310Definition, ...
    "BOOL ILE310::STOP_FM()", ...
    "MATLABName", "STOP_FM", ...
    "Description", "STOP_FM Method of C++ class ILE310."); % Modify help description values as needed.
defineOutput(STOP_FMDefinition, "RetVal", "int32");
validate(STOP_FMDefinition);

%% C++ class method |FM_SAMPLE| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::FM_SAMPLE(FM_SAMPLE_E310 * const FmSample)

%FM_SAMPLEDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::FM_SAMPLE(FM_SAMPLE_E310 * const FmSample)", ...
%    "MATLABName", "FM_SAMPLE", ...
%    "Description", "FM_SAMPLE Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(FM_SAMPLEDefinition, "FmSample", "clib.MyCppLib.FM_SAMPLE_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.FM_SAMPLE_E310", or "clib.array.MyCppLib.FM_SAMPLE_E310"
%defineOutput(FM_SAMPLEDefinition, "RetVal", "int32");
%validate(FM_SAMPLEDefinition);

%% C++ class method |GET_ADC_PARS| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::GET_ADC_PARS(ADC_PARS_E310 * const AdcPars)

%GET_ADC_PARSDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::GET_ADC_PARS(ADC_PARS_E310 * const AdcPars)", ...
%    "MATLABName", "GET_ADC_PARS", ...
%    "Description", "GET_ADC_PARS Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(GET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E310", or "clib.array.MyCppLib.ADC_PARS_E310"
%defineOutput(GET_ADC_PARSDefinition, "RetVal", "int32");
%validate(GET_ADC_PARSDefinition);

%% C++ class method |SET_ADC_PARS| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::SET_ADC_PARS(ADC_PARS_E310 * const AdcPars)

%SET_ADC_PARSDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::SET_ADC_PARS(ADC_PARS_E310 * const AdcPars)", ...
%    "MATLABName", "SET_ADC_PARS", ...
%    "Description", "SET_ADC_PARS Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(SET_ADC_PARSDefinition, "AdcPars", "clib.MyCppLib.ADC_PARS_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.ADC_PARS_E310", or "clib.array.MyCppLib.ADC_PARS_E310"
%defineOutput(SET_ADC_PARSDefinition, "RetVal", "int32");
%validate(SET_ADC_PARSDefinition);

%% C++ class method |GET_ADC_DATA| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::GET_ADC_DATA(ADC_DATA_E310 * const AdcData)

%GET_ADC_DATADefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::GET_ADC_DATA(ADC_DATA_E310 * const AdcData)", ...
%    "MATLABName", "GET_ADC_DATA", ...
%    "Description", "GET_ADC_DATA Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(GET_ADC_DATADefinition, "AdcData", "clib.MyCppLib.ADC_DATA_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.ADC_DATA_E310", or "clib.array.MyCppLib.ADC_DATA_E310"
%defineOutput(GET_ADC_DATADefinition, "RetVal", "int32");
%validate(GET_ADC_DATADefinition);

%% C++ class method |CONFIG_TTL_LINES| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::CONFIG_TTL_LINES(WORD Pattern,BOOL AddTtlLinesEna = 0)

CONFIG_TTL_LINESDefinition = addMethod(ILE310Definition, ...
    "BOOL ILE310::CONFIG_TTL_LINES(WORD Pattern,BOOL AddTtlLinesEna = 0)", ...
    "MATLABName", "CONFIG_TTL_LINES", ...
    "Description", "CONFIG_TTL_LINES Method of C++ class ILE310."); % Modify help description values as needed.
defineArgument(CONFIG_TTL_LINESDefinition, "Pattern", "uint16");
defineArgument(CONFIG_TTL_LINESDefinition, "AddTtlLinesEna", "int32");
defineOutput(CONFIG_TTL_LINESDefinition, "RetVal", "int32");
validate(CONFIG_TTL_LINESDefinition);

%% C++ class method |TTL_IN| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::TTL_IN(WORD * const TtlIn)

%TTL_INDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::TTL_IN(WORD * const TtlIn)", ...
%    "MATLABName", "TTL_IN", ...
%    "Description", "TTL_IN Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(TTL_INDefinition, "TtlIn", "clib.array.MyCppLib.UnsignedShort", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
%defineOutput(TTL_INDefinition, "RetVal", "int32");
%validate(TTL_INDefinition);

%% C++ class method |TTL_OUT| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::TTL_OUT(WORD * const TtlOut)

%TTL_OUTDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::TTL_OUT(WORD * const TtlOut)", ...
%    "MATLABName", "TTL_OUT", ...
%    "Description", "TTL_OUT Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(TTL_OUTDefinition, "TtlOut", "clib.array.MyCppLib.UnsignedShort", "input", <SHAPE>); % <MLTYPE> can be "clib.array.MyCppLib.UnsignedShort", or "uint16"
%defineOutput(TTL_OUTDefinition, "RetVal", "int32");
%validate(TTL_OUTDefinition);

%% C++ class method |ENABLE_FLASH_WRITE| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::ENABLE_FLASH_WRITE(BOOL IsUserFlashWriteEnabled)

ENABLE_FLASH_WRITEDefinition = addMethod(ILE310Definition, ...
    "BOOL ILE310::ENABLE_FLASH_WRITE(BOOL IsUserFlashWriteEnabled)", ...
    "MATLABName", "ENABLE_FLASH_WRITE", ...
    "Description", "ENABLE_FLASH_WRITE Method of C++ class ILE310."); % Modify help description values as needed.
defineArgument(ENABLE_FLASH_WRITEDefinition, "IsUserFlashWriteEnabled", "int32");
defineOutput(ENABLE_FLASH_WRITEDefinition, "RetVal", "int32");
validate(ENABLE_FLASH_WRITEDefinition);

%% C++ class method |READ_FLASH_ARRAY| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::READ_FLASH_ARRAY(USER_FLASH_E310 * const UserFlash)

%READ_FLASH_ARRAYDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::READ_FLASH_ARRAY(USER_FLASH_E310 * const UserFlash)", ...
%    "MATLABName", "READ_FLASH_ARRAY", ...
%    "Description", "READ_FLASH_ARRAY Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(READ_FLASH_ARRAYDefinition, "UserFlash", "clib.MyCppLib.USER_FLASH_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.USER_FLASH_E310", or "clib.array.MyCppLib.USER_FLASH_E310"
%defineOutput(READ_FLASH_ARRAYDefinition, "RetVal", "int32");
%validate(READ_FLASH_ARRAYDefinition);

%% C++ class method |WRITE_FLASH_ARRAY| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::WRITE_FLASH_ARRAY(USER_FLASH_E310 * const UserFlash)

%WRITE_FLASH_ARRAYDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::WRITE_FLASH_ARRAY(USER_FLASH_E310 * const UserFlash)", ...
%    "MATLABName", "WRITE_FLASH_ARRAY", ...
%    "Description", "WRITE_FLASH_ARRAY Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(WRITE_FLASH_ARRAYDefinition, "UserFlash", "clib.MyCppLib.USER_FLASH_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.USER_FLASH_E310", or "clib.array.MyCppLib.USER_FLASH_E310"
%defineOutput(WRITE_FLASH_ARRAYDefinition, "RetVal", "int32");
%validate(WRITE_FLASH_ARRAYDefinition);

%% C++ class method |GET_MODULE_DESCRIPTION| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E310 * const md)

%GET_MODULE_DESCRIPTIONDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::GET_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E310 * const md)", ...
%    "MATLABName", "GET_MODULE_DESCRIPTION", ...
%    "Description", "GET_MODULE_DESCRIPTION Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(GET_MODULE_DESCRIPTIONDefinition, "md", "clib.MyCppLib.MODULE_DESCRIPTION_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E310", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E310"
%defineOutput(GET_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
%validate(GET_MODULE_DESCRIPTIONDefinition);

%% C++ class method |SAVE_MODULE_DESCRIPTION| for C++ class |ILE310| 
% C++ Signature: BOOL ILE310::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E310 * const md)

%SAVE_MODULE_DESCRIPTIONDefinition = addMethod(ILE310Definition, ...
%    "BOOL ILE310::SAVE_MODULE_DESCRIPTION(MODULE_DESCRIPTION_E310 * const md)", ...
%    "MATLABName", "SAVE_MODULE_DESCRIPTION", ...
%    "Description", "SAVE_MODULE_DESCRIPTION Method of C++ class ILE310."); % Modify help description values as needed.
%defineArgument(SAVE_MODULE_DESCRIPTIONDefinition, "md", "clib.MyCppLib.MODULE_DESCRIPTION_E310", "input", <SHAPE>); % <MLTYPE> can be "clib.MyCppLib.MODULE_DESCRIPTION_E310", or "clib.array.MyCppLib.MODULE_DESCRIPTION_E310"
%defineOutput(SAVE_MODULE_DESCRIPTIONDefinition, "RetVal", "int32");
%validate(SAVE_MODULE_DESCRIPTIONDefinition);

%% C++ class |_myOVERLAPPED| with MATLAB name |clib.MyCppLib.myOVERLAPPED| 
myOVERLAPPEDDefinition = addClass(libDef, "_myOVERLAPPED", "MATLABName", "clib.MyCppLib.myOVERLAPPED", ...
    "Description", "clib.MyCppLib.myOVERLAPPED    Representation of C++ class _myOVERLAPPED."); % Modify help description values as needed.

%% C++ class constructor for C++ class |_myOVERLAPPED| 
% C++ Signature: _myOVERLAPPED::_myOVERLAPPED(_myOVERLAPPED const & input1)

myOVERLAPPEDConstructor1Definition = addConstructor(myOVERLAPPEDDefinition, ...
    "_myOVERLAPPED::_myOVERLAPPED(_myOVERLAPPED const & input1)", ...
    "Description", "clib.MyCppLib.myOVERLAPPED Constructor of C++ class _myOVERLAPPED."); % Modify help description values as needed.
defineArgument(myOVERLAPPEDConstructor1Definition, "input1", "clib.MyCppLib.myOVERLAPPED", "input");
validate(myOVERLAPPEDConstructor1Definition);

%% C++ class constructor for C++ class |_myOVERLAPPED| 
% C++ Signature: _myOVERLAPPED::_myOVERLAPPED()

myOVERLAPPEDConstructor2Definition = addConstructor(myOVERLAPPEDDefinition, ...
    "_myOVERLAPPED::_myOVERLAPPED()", ...
    "Description", "clib.MyCppLib.myOVERLAPPED Constructor of C++ class _myOVERLAPPED."); % Modify help description values as needed.
validate(myOVERLAPPEDConstructor2Definition);

%% C++ class public data member |Internal| for C++ class |_myOVERLAPPED| 
% C++ Signature: ULONG_PTR _myOVERLAPPED::Internal

addProperty(myOVERLAPPEDDefinition, "Internal", "uint64", ...
    "Description", "uint64    Data member of C++ class _myOVERLAPPED."); % Modify help description values as needed.

%% C++ class public data member |InternalHigh| for C++ class |_myOVERLAPPED| 
% C++ Signature: ULONG_PTR _myOVERLAPPED::InternalHigh

addProperty(myOVERLAPPEDDefinition, "InternalHigh", "uint64", ...
    "Description", "uint64    Data member of C++ class _myOVERLAPPED."); % Modify help description values as needed.

%% C++ class public data member |Offset| for C++ class |_myOVERLAPPED| 
% C++ Signature: DWORD _myOVERLAPPED::Offset

addProperty(myOVERLAPPEDDefinition, "Offset", "uint32", ...
    "Description", "uint32    Data member of C++ class _myOVERLAPPED."); % Modify help description values as needed.

%% C++ class public data member |OffsetHigh| for C++ class |_myOVERLAPPED| 
% C++ Signature: DWORD _myOVERLAPPED::OffsetHigh

addProperty(myOVERLAPPEDDefinition, "OffsetHigh", "uint32", ...
    "Description", "uint32    Data member of C++ class _myOVERLAPPED."); % Modify help description values as needed.

%% C++ function |GetDllVersion| with MATLAB name |clib.MyCppLib.GetDllVersion|
% C++ Signature: DWORD GetDllVersion()

GetDllVersionDefinition = addFunction(libDef, ...
    "DWORD GetDllVersion()", ...
    "MATLABName", "clib.MyCppLib.GetDllVersion", ...
    "Description", "clib.MyCppLib.GetDllVersion Representation of C++ function GetDllVersion."); % Modify help description values as needed.
defineOutput(GetDllVersionDefinition, "RetVal", "uint32");
validate(GetDllVersionDefinition);

%% C++ function |CreateLInstance| with MATLAB name |clib.MyCppLib.CreateLInstance|
% C++ Signature: LPVOID CreateLInstance(char const * const DeviceName)

CreateLInstanceDefinition = addFunction(libDef, ...
   "LPVOID CreateLInstance(char const * const DeviceName)", ...
   "MATLABName", "clib.MyCppLib.CreateLInstance", ...
   "Description", "clib.MyCppLib.CreateLInstance Representation of C++ function CreateLInstance."); % Modify help description values as needed.
defineArgument(CreateLInstanceDefinition, "DeviceName", "string", "input", "nullTerminated"); % <MLTYPE> can be "clib.array.MyCppLib.Char","int8","string", or "char"
defineOutput(CreateLInstanceDefinition, "RetVal", "clib.MyCppLib.LPVOID", 1);
validate(CreateLInstanceDefinition);

%% C++ function |GetILE440Instance| with MATLAB name |clib.MyCppLib.GetILE440Instance|
% C++ Signature: ILE440 * GetILE440Instance()

GetILE440InstanceDefinition = addFunction(libDef, ...
   "ILE440 * GetILE440Instance()", ...
   "MATLABName", "clib.MyCppLib.GetILE440Instance", ...
   "Description", "clib.MyCppLib.GetILE440Instance Representation of C++ function GetILE440Instance."); % Modify help description values as needed.
defineOutput(GetILE440InstanceDefinition, "RetVal", "clib.MyCppLib.ILE440", 1);
validate(GetILE440InstanceDefinition);

%% C++ function |SetBuffer| with MATLAB name |clib.MyCppLib.SetBuffer|
% C++ Signature: void SetBuffer(IO_REQUEST_LUSBAPI * req,SHORT * buffer,DWORD count)

SetBufferDefinition = addFunction(libDef, ...
   "void SetBuffer(IO_REQUEST_LUSBAPI * req,SHORT * buffer,DWORD count)", ...
   "MATLABName", "clib.MyCppLib.SetBuffer", ...
   "Description", "clib.MyCppLib.SetBuffer Representation of C++ function SetBuffer."); % Modify help description values as needed.
defineArgument(SetBufferDefinition, "req", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", 1); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
defineArgument(SetBufferDefinition, "buffer", "clib.array.MyCppLib.Short", "input", 256*1024); % <MLTYPE> can be "clib.array.MyCppLib.Short", or "int16"
defineArgument(SetBufferDefinition, "count", "uint32");
validate(SetBufferDefinition);

%% C++ function |SetOverlapped| with MATLAB name |clib.MyCppLib.SetOverlapped|
% C++ Signature: void SetOverlapped(IO_REQUEST_LUSBAPI * req,myOVERLAPPED * myOver,BOOL manualReset,BOOL initialState)

SetOverlappedDefinition = addFunction(libDef, ...
   "void SetOverlapped(IO_REQUEST_LUSBAPI * req,myOVERLAPPED * myOver,BOOL manualReset,BOOL initialState)", ...
   "MATLABName", "clib.MyCppLib.SetOverlapped", ...
   "Description", "clib.MyCppLib.SetOverlapped Representation of C++ function SetOverlapped."); % Modify help description values as needed.
defineArgument(SetOverlappedDefinition, "req", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", 1); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
defineArgument(SetOverlappedDefinition, "myOver", "clib.MyCppLib.myOVERLAPPED", "input", 1); % <MLTYPE> can be "clib.MyCppLib.myOVERLAPPED", or "clib.array.MyCppLib.myOVERLAPPED"
defineArgument(SetOverlappedDefinition, "manualReset", "int32");
defineArgument(SetOverlappedDefinition, "initialState", "int32");
validate(SetOverlappedDefinition);


%% C++ function |MyWaitForEvent| with MATLAB name |clib.MyCppLib.MyWaitForEvent|
%C++ Signature: DWORD MyWaitForEvent(IO_REQUEST_LUSBAPI * req,DWORD timeout)

MyWaitForEventDefinition = addFunction(libDef, ...
   "DWORD MyWaitForEvent(IO_REQUEST_LUSBAPI * req,DWORD timeout)", ...
   "MATLABName", "clib.MyCppLib.MyWaitForEvent", ...
   "Description", "clib.MyCppLib.MyWaitForEvent Representation of C++ function MyWaitForEvent."); % Modify help description values as needed.
defineArgument(MyWaitForEventDefinition, "req", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", 1); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
defineArgument(MyWaitForEventDefinition, "timeout", "uint32");
defineOutput(MyWaitForEventDefinition, "RetVal", "uint32");
validate(MyWaitForEventDefinition);

%% C++ function |MyCloseHandle| with MATLAB name |clib.MyCppLib.MyCloseHandle|
% C++ Signature: BOOL MyCloseHandle(IO_REQUEST_LUSBAPI * req)

MyCloseHandleDefinition = addFunction(libDef, ...
   "BOOL MyCloseHandle(IO_REQUEST_LUSBAPI * req)", ...
   "MATLABName", "clib.MyCppLib.MyCloseHandle", ...
   "Description", "clib.MyCppLib.MyCloseHandle Representation of C++ function MyCloseHandle."); % Modify help description values as needed.
defineArgument(MyCloseHandleDefinition, "req", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input",1); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
defineOutput(MyCloseHandleDefinition, "RetVal", "int32");
validate(MyCloseHandleDefinition);

%% C++ function |MyResetEvent| with MATLAB name |clib.MyCppLib.MyResetEvent|
% C++ Signature: BOOL MyResetEvent(IO_REQUEST_LUSBAPI * req)

MyResetEventDefinition = addFunction(libDef, ...
   "BOOL MyResetEvent(IO_REQUEST_LUSBAPI * req)", ...
   "MATLABName", "clib.MyCppLib.MyResetEvent", ...
   "Description", "clib.MyCppLib.MyResetEvent Representation of C++ function MyResetEvent."); % Modify help description values as needed.
defineArgument(MyResetEventDefinition, "req", "clib.MyCppLib.IO_REQUEST_LUSBAPI", "input", 1); % <MLTYPE> can be "clib.MyCppLib.IO_REQUEST_LUSBAPI", or "clib.array.MyCppLib.IO_REQUEST_LUSBAPI"
defineOutput(MyResetEventDefinition, "RetVal", "int32");
validate(MyResetEventDefinition);

%% Validate the library definition
validate(libDef);

end
