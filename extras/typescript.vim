syntax region  tsDefinition     contained                        start=/:/    end=/\%(\s*[,=;)\n]\)\@=/ contains=@tsCluster containedin=jsParen
syntax region  tsArgumentDef    contained                        start=/:/    end=/\%(\s*[,)]\|=>\@!\)\@=/ contains=@tsCluster
syntax region  tsArray          contained matchgroup=tsNoise start=/\[/   end=/\]/        contains=@tsCluster,jsComment fold
syntax region  tsObject         contained matchgroup=tsNoise start=/{/    end=/}/         contains=@tsCluster,jsComment fold
syntax region  tsExactObject    contained matchgroup=tsNoise start=/{|/   end=/|}/       contains=@tsCluster,jsComment fold
syntax region  tsParens         contained matchgroup=tsNoise start=/(/  end=/)/ contains=@tsCluster nextgroup=tsArrow skipwhite keepend extend fold
syntax match   tsNoise          contained /[:;,<>]/
syntax keyword tsType           contained boolean number string null void any mixed JSON array Function object array bool class
syntax keyword tsTypeof         contained typeof skipempty skipwhite nextgroup=tsTypeCustom,tsType
syntax match   tsTypeCustom     contained /[0-9a-zA-Z_.]*/ skipwhite skipempty nextgroup=tsGeneric
syntax region  tsGeneric                  matchgroup=tsNoise start=/\k\@<=</ end=/>/ contains=@tsCluster containedin=@jsExpression,tsDeclareBlock
" syntax region  tsGeneric        contained matchgroup=tsNoise start=/</ end=/>(\@=/ oneline contains=@tsCluster containedin=@jsExpression,tsDeclareBlock
syntax region  tsObjectGeneric  contained matchgroup=tsNoise start=/\k\@<=</ end=/>/ contains=@tsCluster nextgroup=jsFuncArgs
syntax match   tsArrow          contained /=>/ skipwhite skipempty nextgroup=tsType,tsTypeCustom,tsParens
syntax match   tsObjectKey      contained /[0-9a-zA-Z_$?]*\(\s*:\)\@=/ contains=jsFunctionKey,tsMaybe skipwhite skipempty nextgroup=jsObjectValue containedin=jsObject
syntax match   tsOrOperator     contained /|/ skipwhite skipempty nextgroup=@tsCluster
syntax keyword tsImportType     contained type typeof skipwhite skipempty nextgroup=jsModuleAsterisk,jsModuleKeyword,jsModuleGroup
syntax match   tsWildcard       contained /*/

syntax match   tsReturn         contained /:\s*/ contains=tsNoise skipwhite skipempty nextgroup=@tsReturnCluster,tsArrow,tsReturnParens
syntax region  tsReturnObject   contained matchgroup=tsNoise start=/{/    end=/}/  contains=@tsCluster skipwhite skipempty nextgroup=jsFuncBlock,tsReturnOrOp extend fold
syntax region  tsReturnArray    contained matchgroup=tsNoise start=/\[/   end=/\]/ contains=@tsCluster skipwhite skipempty nextgroup=jsFuncBlock,tsReturnOrOp fold
syntax region  tsReturnParens   contained matchgroup=tsNoise start=/(/    end=/)/  contains=@tsCluster skipwhite skipempty nextgroup=jsFuncBlock,tsReturnOrOp,tsReturnArrow fold
syntax match   tsReturnArrow    contained /=>/ skipwhite skipempty nextgroup=@tsReturnCluster
syntax match   tsReturnKeyword  contained /\k\+/ contains=tsType,tsTypeCustom skipwhite skipempty nextgroup=tsReturnGroup,jsFuncBlock,tsReturnOrOp,tsReturnArray
syntax match   tsReturnMaybe    contained /?/ skipwhite skipempty nextgroup=tsReturnKeyword,tsReturnObject,tsReturnParens
syntax region  tsReturnGroup    contained matchgroup=tsNoise start=/</ end=/>/ contains=@tsCluster skipwhite skipempty nextgroup=jsFuncBlock,tsReturnOrOp
syntax match   tsReturnOrOp     contained /\s*|\s*/ skipwhite skipempty nextgroup=@tsReturnCluster
syntax match   tsWildcardReturn contained /*/ skipwhite skipempty nextgroup=jsFuncBlock
syntax keyword tsTypeofReturn   contained typeof skipempty skipwhite nextgroup=@tsReturnCluster

syntax region  tsFunctionGroup      contained matchgroup=tsNoise start=/</ end=/>/ contains=@tsCluster skipwhite skipempty nextgroup=jsFuncArgs
syntax region  tsClassGroup         contained matchgroup=tsNoise start=/</ end=/>/ contains=@tsCluster skipwhite skipempty nextgroup=jsClassBlock
syntax region  tsClassFunctionGroup contained matchgroup=tsNoise start=/</ end=/>/ contains=@tsCluster skipwhite skipempty nextgroup=jsFuncArgs
syntax match   tsObjectFuncName contained /\<\K\k*<\@=/ skipwhite skipempty nextgroup=tsObjectGeneric containedin=jsObject

syntax region  tsTypeStatement                                   start=/\(opaque\s\+\)\?type\%(\s\+\k\)\@=/    end=/=\@=/ contains=tsTypeOperator oneline skipwhite skipempty nextgroup=tsTypeValue keepend
syntax region  tsTypeValue      contained     matchgroup=tsNoise start=/=/ end=/\%(;\|\n\%(\s*|\)\@!\)/ contains=@tsCluster,tsGeneric,tsMaybe
syntax match   tsTypeOperator   contained /=/ containedin=tsTypeValue
syntax match   tsTypeOperator   contained /=/
syntax keyword tsTypeKeyword    contained type

syntax keyword tsDeclare                  declare skipwhite skipempty nextgroup=tsTypeStatement,jsClassDefinition,jsStorageClass,tsModule,tsInterface
syntax match   tsClassProperty  contained /\<[0-9a-zA-Z_$]*\>:\@=/ skipwhite skipempty nextgroup=tsClassDef containedin=jsClassBlock
syntax region  tsClassDef       contained start=/:/    end=/\%(\s*[,=;)\n]\)\@=/ contains=@tsCluster skipwhite skipempty nextgroup=jsClassValue

syntax region  tsModule         contained start=/module/ end=/\%({\|:\)\@=/ skipempty skipwhite nextgroup=tsDeclareBlock contains=jsString
syntax region  tsInterface      contained start=/interface/ end=/{\@=/ skipempty skipwhite nextgroup=tsInterfaceBlock contains=@tsCluster
syntax region  tsDeclareBlock   contained matchgroup=tsNoise start=/{/ end=/}/ contains=tsDeclare,tsNoise fold

syntax match   tsMaybe          contained /?/
syntax region  tsInterfaceBlock contained matchgroup=tsNoise start=/{/ end=/}/ contains=jsObjectKey,jsObjectKeyString,jsObjectKeyComputed,jsObjectSeparator,jsObjectFuncName,tsObjectFuncName,jsObjectMethodType,jsGenerator,jsComment,jsObjectStringKey,jsSpreadExpression,tsNoise,tsParens,tsGeneric keepend fold

syntax region  tsParenAnnotation contained start=/:/ end=/[,=)]\@=/ containedin=jsParen contains=@tsCluster

syntax cluster tsReturnCluster            contains=tsNoise,tsReturnObject,tsReturnArray,tsReturnKeyword,tsReturnGroup,tsReturnMaybe,tsReturnOrOp,tsWildcardReturn,tsReturnArrow,tsTypeofReturn
syntax cluster tsCluster                  contains=tsArray,tsObject,tsExactObject,tsNoise,tsTypeof,tsType,tsGeneric,tsMaybe,tsParens,tsOrOperator,tsWildcard

if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink tsDefinition         PreProc
  HiLink tsClassDef           tsDefinition
  HiLink tsArgumentDef        tsDefinition
  HiLink tsType               Type
  HiLink tsTypeCustom         PreProc
  HiLink tsTypeof             PreProc
  HiLink tsTypeofReturn       PreProc
  HiLink tsArray              PreProc
  HiLink tsObject             PreProc
  HiLink tsExactObject        PreProc
  HiLink tsParens             PreProc
  HiLink tsGeneric            PreProc
  HiLink tsObjectGeneric      tsGeneric
  HiLink tsReturn             PreProc
  HiLink tsParenAnnotation    PreProc
  HiLink tsReturnObject       tsReturn
  HiLink tsReturnArray        tsArray
  HiLink tsReturnParens       tsParens
  HiLink tsReturnGroup        tsGeneric
  HiLink tsFunctionGroup      PreProc
  HiLink tsClassGroup         PreProc
  HiLink tsClassFunctionGroup PreProc
  HiLink tsArrow              PreProc
  HiLink tsReturnArrow        PreProc
  HiLink tsTypeStatement      PreProc
  HiLink tsTypeKeyword        PreProc
  HiLink tsTypeOperator       Operator
  HiLink tsMaybe              PreProc
  HiLink tsReturnMaybe        PreProc
  HiLink tsClassProperty      jsClassProperty
  HiLink tsDeclare            PreProc
  HiLink tsModule             PreProc
  HiLink tsInterface          PreProc
  HiLink tsNoise              Noise
  HiLink tsObjectKey          jsObjectKey
  HiLink tsOrOperator         jsOperator
  HiLink tsReturnOrOp         tsOrOperator
  HiLink tsWildcard           PreProc
  HiLink tsWildcardReturn     PreProc
  HiLink tsImportType         PreProc
  HiLink tsTypeValue          PreProc
  HiLink tsObjectFuncName     jsObjectFuncName

  " Reskin
  HiLink tsDefinition         Comment
  HiLink tsClassDef           Type
  HiLink tsArgumentDef        Type
  HiLink tsType               Constant
  HiLink tsTypeCustom         Type
  HiLink tsTypeof             Type
  HiLink tsArray              Label
  HiLink tsObject             Normal
  HiLink tsExactObject        Normal
  HiLink tsParens             Operator
  HiLink tsGroup              Type
  HiLink tsReturn             Type
  HiLink tsParenAnnotation    Comment
  HiLink tsReturnObject       Type
  HiLink tsReturnArray        Type
  HiLink tsReturnParens       Operator
  HiLink tsReturnGroup        Type
  HiLink tsFunctionGroup      Type
  HiLink tsClassGroup         Type
  HiLink tsClassFunctionGroup Type
  HiLink tsArrowArguments     Type
  HiLink tsArrow              Operator
  HiLink tsReturnArrow        Operator
  HiLink tsTypeStatement      StorageClass
  HiLink tsTypeKeyword        StorageClass
  HiLink tsTypeOperator       StorageClass
  HiLink tsMaybe              Operator
  HiLink tsReturnMaybe        Operator
  HiLink tsClassProperty      Normal
  HiLink tsDeclare            Include
  HiLink tsModule             Include
  HiLink tsInterface          Include
  HiLink tsNoise              Normal
  HiLink tsObjectKey          Normal
  HiLink tsOrOperator         Operator
  HiLink tsReturnOrOp         Operator
  HiLink tsWildcard           Operator
  HiLink tsWildcardReturn     Operator
  HiLink tsImportType         StorageClass
  HiLink tsTypeValue          Type

  HiLink xmlTag    Tag
  HiLink xmlEndTag Tag
  delcommand HiLink
endif
