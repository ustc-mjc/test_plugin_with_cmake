#include <jni.h>
#include <string>
#include "calculator.h"

extern "C" JNIEXPORT jstring JNICALL
Java_com_example_calculator_Calculator_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_example_calculator_Calculator_getVersion(
        JNIEnv* env,
        jobject /* this */) {
    std::string version = Calculator::getVersion();
    return env->NewStringUTF(version.c_str());
}

extern "C" JNIEXPORT jint JNICALL
Java_com_example_calculator_Calculator_add(
        JNIEnv* env,
        jobject /* this */, jint a, jint b) {
    Calculator calculator;
    int sum = calculator.add(a, b);
    return sum;
}

extern "C" JNIEXPORT jint JNICALL
Java_com_example_calculator_Calculator_sub(
        JNIEnv* env,
        jobject /* this */, jint a, jint b) {
    Calculator calculator;
    int sub = calculator.sub(a, b);
    return sub;
}
