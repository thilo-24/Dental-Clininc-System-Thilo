package com.sunrisedental.model;

import java.util.List;

public class Doctor {
    private int id;
    private String doctorName;
    private String specialization;
    private boolean active;
    private List<Integer> treatmentIds;

    public Doctor() {}

    public Doctor(int id, String doctorName, String specialization, boolean active) {
        this.id = id;
        this.doctorName = doctorName;
        this.specialization = specialization;
        this.active = active;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public List<Integer> getTreatmentIds() { return treatmentIds; }
    public void setTreatmentIds(List<Integer> treatmentIds) { this.treatmentIds = treatmentIds; }
}