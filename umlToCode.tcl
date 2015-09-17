package require tdom
package require Itcl

catch { itcl::delete class ClassDef CodeWriter}

itcl::class ClassDef {
    variable name ""
    variable vars ""
    variable meths ""
    
    constructor { n v m } {
        set name [join $n]
        set vars $v
        set meths $m
    }
    
    public {
    
        method GetName { } {
            return $name
        }
        
        method GetVariables { } {
            return $vars
        }
        
        method GetMethods { } {
            return $meths
        }
    }
}

itcl::class CodeWriter {
    public {
        variable classDefObjs
        variable outFile
        variable umlFile
    }
    public {
         method WriteTclCode { } {
            if { $outFile != "" } {
                set fid [open $outFile w]
                if { [catch { \
                    foreach classDefObj $classDefObjs {
                        puts $fid "## \\brief [$classDefObj GetName] Class"
                        puts $fid "itcl::class [$classDefObj GetName] {"
                        set vars [$classDefObj GetVariables]
                        foreach var $vars {
                            puts $fid "    variable $var"
                        }
                        set methods  [$classDefObj GetMethods]
                        foreach methodSignature $methods {
                            if { $methodSignature == "" } { continue }
                            puts $fid  "    ## \\brief"
                            puts $fid "    method $methodSignature"
                        }
                        puts $fid "}"
                        foreach methodSignature $methods {
                            if { $methodSignature == "" } { continue }
                            puts $fid "itcl::body [string trim [$classDefObj GetName]]::$methodSignature {"
                            puts $fid "}"
                        }
                        puts $fid ""
                    }
                } ] } {
                    close $fid
                }
                close $fid
            }
        }
        
         method GetOutFile { } {
            return $outFile
        }
        
         method SetOutfile { filePath } { 
            set outFile $filePath
        }
        
         method SetUmlFile { filePath } {
            set umlFile $filePath
        }
        
         method ReadUmlFile { } {
            set fid [open $umlFile r]
            set xmlText [read $fid]
            close $fid
            set doc [dom parse $xmlText]
            
            set lst_classNodes [$doc getElementsByTagName panel_attributes]
            foreach classNode $lst_classNodes {
                if { [[[$classNode parentNode] getElementsByTagName id] text] == "UMLClass" } {
                    set classDef [$classNode text]
                    set classDefList [split [split $classDef \n] --]
                    set classContent ""
                    foreach item $classDefList {
                        if { $item != "" } {
                            lappend classContent $item
                        }
                    }    
                    puts "@@ $classContent "
                    if { [llength $classContent] <= 3 } {
                        lappend classDefObjs [ClassDef #auto \
                                     [lindex $classContent 0] \
                                     [lindex $classContent 1] \
                                     [lindex $classContent 2]]
                    }
                }
            }
        }
    }
}

set writerObj [CodeWriter #auto]
$writerObj SetUmlFile [file join [file dir [info script]] test.uxf]
$writerObj SetOutfile [file join [file dir [info script]] test.tcl]
$writerObj ReadUmlFile
$writerObj WriteTclCode
