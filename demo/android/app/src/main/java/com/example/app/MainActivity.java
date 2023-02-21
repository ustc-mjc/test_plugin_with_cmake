package com.example.app;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.TextView;

import com.example.app.databinding.ActivityMainBinding;
import com.example.calculator.Calculator;

public class MainActivity extends AppCompatActivity {

    // Used to load the 'app' library on application startup.

    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        // Example of a call to a native method
        TextView tv = binding.sampleText;
        Calculator calculator = new Calculator();
//        String version =  calculator.getVersion();
        int sum = calculator.add(1,1);
//        tv.setText("version:" + version + "1+1=" + sum);
        tv.setText("version:" + sum);
    }

    /**
     * A native method that is implemented by the 'app' native library,
     * which is packaged with this application.
     */
}