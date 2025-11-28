#!/bin/bash

# Test that invalid code fails to compile with the expected error
# This ensures type checking is working correctly through the public API

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.."

echo "Testing that invalid code fails to compile..."
BUILD_OUTPUT=$(swift build --target InvalidCode 2>&1)
BUILD_EXIT_CODE=$?

echo -e "Build output:\n $BUILD_OUTPUT"

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo "ERROR: Invalid code compiled successfully! Type checking may not be working correctly."
    exit 1
fi

if [[ $BUILD_OUTPUT != *"'PredicateBuilder' requires that 'NSString' inherit from 'NSManagedObject'"* ]]; then 
    echo "ERROR: Compilation failed, but for the wrong reason!"
    echo "Expected error message about 'NSString' inheriting from 'NSManagedObject'"
    echo "Make sure the compiler is not inferring the root type to be 'NSManagedObject'"
    exit 1
fi

echo "✅ The compiler failed in the expected manner. The PredicateBuilder's type checking is working correctly through the public API."

