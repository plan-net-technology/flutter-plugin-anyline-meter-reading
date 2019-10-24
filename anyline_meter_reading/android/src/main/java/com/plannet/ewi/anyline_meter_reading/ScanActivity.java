package com.plannet.ewi.anyline_meter_reading;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import at.nineyards.anyline.camera.CameraController;
import at.nineyards.anyline.camera.CameraOpenListener;
import io.anyline.plugin.ScanResultListener;
import io.anyline.plugin.meter.MeterScanMode;
import io.anyline.plugin.meter.MeterScanResult;
import io.anyline.plugin.meter.MeterScanViewPlugin;
import io.anyline.view.BaseScanViewConfig;
import io.anyline.view.ScanView;
import io.anyline.view.ScanViewPluginConfig;

public class ScanActivity extends AppCompatActivity implements CameraOpenListener {
    private String licenseKey;
    protected ScanView scanView;
    private static final int cameraPermissionRequestCode = 100;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        extractLicenseKey();
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, cameraPermissionRequestCode);
        } else {
            setupScanView();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == cameraPermissionRequestCode) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                setupScanView();
            } else {
                handleCameraPermissionError();
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (scanView != null) {
            scanView.start();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (scanView != null) {
            scanView.stop();
            scanView.releaseCameraInBackground();
        }
    }

    @Override
    public void onCameraOpened(final CameraController cameraController, int width, int height) {
    }

    @Override
    public void onCameraError(Exception e) {
        handleDefaultError(e);
    }

    private void extractLicenseKey() {
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            licenseKey = extras.getString(Constants.KEY_LICENSE_KEY);
        }
    }

    private void setupScanView() {
        setContentView(R.layout.activity_scan);

        scanView = findViewById(R.id.scan_view);
        scanView.setCameraOpenListener(this);

        ScanViewPluginConfig scanViewPluginConfig = new ScanViewPluginConfig(getApplicationContext(), Constants.CONFIG_FILE_NAME);
        MeterScanViewPlugin scanViewPlugin = new MeterScanViewPlugin(getApplicationContext(), licenseKey, scanViewPluginConfig, "METER");
        BaseScanViewConfig baseScanViewConfig = new BaseScanViewConfig(getApplicationContext(), Constants.CONFIG_FILE_NAME);
        scanView.setScanViewConfig(baseScanViewConfig);
        scanView.setScanViewPlugin(scanViewPlugin);

        scanViewPlugin.addScanResultListener((ScanResultListener<MeterScanResult>) this::handleScanResult);

        ((MeterScanViewPlugin) scanView.getScanViewPlugin()).setScanMode(MeterScanMode.AUTO_ANALOG_DIGITAL_METER);

        scanView.start();
    }

    private void handleScanResult(MeterScanResult meterScanResult) {
        setResult(
                Constants.RESULT_SUCCESS,
                new Intent().putExtra(
                        Constants.KEY_METER_VALUE, meterScanResult.getResult()
                )
        );
        finish();
    }

    private void handleDefaultError(Exception e) {
        setResult(
                Constants.RESULT_ERROR_DEFAULT,
                new Intent().putExtra(Constants.KEY_EXCEPTION, e.toString())
        );
        finish();
    }

    private void handleCameraPermissionError() {
        setResult(Constants.RESULT_ERROR_CAMERA_PERMISSION);
        finish();
    }
}
