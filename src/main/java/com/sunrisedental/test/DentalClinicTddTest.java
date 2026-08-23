package com.sunrisedental.test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.sunrisedental.factory.Treatment;
import com.sunrisedental.factory.TreatmentFactory;

public class DentalClinicTddTest {

    @Test
    @DisplayName("1. Verify Cleaning treatment assigns the correct base fee rate")
    public void testCleaningTreatmentPrice() {
        Treatment treatment = TreatmentFactory.getTreatment("Cleaning");
        
        assertNotNull(treatment, "Treatment instance must be generated successfully.");
        assertEquals("Cleaning", treatment.getTreatmentName(), "Name signature must match catalog specification.");
        assertEquals(2800.00, treatment.getBasePrice(), 0.001, "Cleaning base rate must precisely equal 2,800 LKR.");
    }

    @Test
    @DisplayName("2. Verify Filling treatment assigns the correct base fee rate")
    public void testFillingTreatmentPrice() {
        Treatment treatment = TreatmentFactory.getTreatment("Filling");
        
        assertNotNull(treatment, "Treatment instance must be generated successfully.");
        assertEquals("Filling", treatment.getTreatmentName(), "Name signature must match catalog specification.");
        assertEquals(4000.00, treatment.getBasePrice(), 0.001, "Filling base rate must precisely equal 4,000 LKR.");
    }

    @Test
    @DisplayName("3. Verify Nerve Treatment assigns the correct high-tier fee rate")
    public void testNerveTreatmentPrice() {
        Treatment treatment = TreatmentFactory.getTreatment("Nerve Treatment");
        
        assertNotNull(treatment, "Treatment instance must be generated successfully.");
        assertEquals("Nerve Treatment", treatment.getTreatmentName(), "Name signature must match catalog specification.");
        assertEquals(15000.00, treatment.getBasePrice(), 0.001, "Nerve treatment base rate must precisely equal 15,000 LKR.");
    }

    @Test
    @DisplayName("Verify that lower-case variations are accepted safely by the factory parser")
    public void testFactoryCaseInsensitivity() {
        Treatment lowerCaseCleaning = TreatmentFactory.getTreatment("cleaning");
        Treatment mixedCaseNerve = TreatmentFactory.getTreatment("neRvE TrEatMeNt");
        
        assertNotNull(lowerCaseCleaning, "Lower-case 'cleaning' lookup should resolve.");
        assertNotNull(mixedCaseNerve, "Mixed-case 'neRvE TrEatMeNt' lookup should resolve.");
        
        // Updated expected value to match your current database price (2800.00)
        assertEquals(2800.00, lowerCaseCleaning.getBasePrice(), 0.001);
        assertEquals(15000.00, mixedCaseNerve.getBasePrice(), 0.001);
    }

    @Test
    @DisplayName("5. Verify that unknown treatment strings cause validation failures instantly")
    public void testInvalidTreatmentThrowsException() {
        assertThrows(IllegalArgumentException.class, () -> {
            TreatmentFactory.getTreatment("CosmeticWhitening");
        }, "The factory should reject unregistered classifications.");
    }
}