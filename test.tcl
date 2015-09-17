## \brief SimpleClass Class
itcl::class SimpleClass {
    variable var1
    variable var2
    ## \brief
    method method1 { arg1 }
    ## \brief
    method method2 { arg1 }
}
itcl::body SimpleClass::method1 { arg1 } {
}
itcl::body SimpleClass::method2 { arg1 } {
}

## \brief SimpleClass Class
itcl::class SimpleClass {
    variable var1
    ## \brief
    method method1 { arg1 }
}
itcl::body SimpleClass::method1 { arg1 } {
}

## \brief AbstractClass  Class
itcl::class AbstractClass  {
}

