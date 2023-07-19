#!/bin/bash

cd ..

BUILD_OUTPUT=$(swift build)
echo -e "Build output:\n $BUILD_OUTPUT"

if [[ $BUILD_OUTPUT != *"'PredicateBuilder' requires that 'NSString' inherit from 'NSManagedObject'"* ]]; then 
    echo "Compiling main.swift either succeeded, or failed for the wrong reason! Make sure the compiler is not inferring the root type to be 'NSManagedObject'"
    exit 1
fi

echo "The compiler failed in the expected manner. The PredicateBuilder's type checking is working correctly ✅"
