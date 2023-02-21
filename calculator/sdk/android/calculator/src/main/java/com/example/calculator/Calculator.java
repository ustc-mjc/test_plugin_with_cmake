package com.example.calculator;

public class Calculator {

    // Used to load the 'calculator' library on application startup.
    static {
        System.loadLibrary("calculator");
    }

    /**
     * A native method that is implemented by the 'calculator' native library,
     * which is packaged with this application.
     */
    public native String stringFromJNI();
    public native String getVersion();
    public native int add(int a, int b);
    public native int sub(int a, int b);
}