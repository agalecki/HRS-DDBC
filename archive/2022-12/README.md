# HRS-DDBC project

 This project is devoted to developing a library of SAS macros for extracting HRS data. The macros are stored in `hrs-macros` subfolder
and  listed in the table below.

 
* Typically these macros can be executed in one of the two modes: **test** or **regular** mode
* Execution mode of a given macro is determined based on the value of the `outinfo` argument
    - By default the `outinfo` argument is blank and macro is executed in a regular mode
    - If the `outinfo` argument is not blank  the `funcd` macro is executed in a test mode

 
| Macro           | Description                     | Mandatory arguments             |
| :---            | :-----                          | :-----                          |
| `funcd`         | Creates ADL and IADL variables  | `years`,   `libin =`, `outdt =` | 
| `health`        | Creates health variables        | `years `,  `libin =`, `outdt =` | 
