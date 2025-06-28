package com.example;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class MathUtilsTest {

    private MathUtils mathUtils;

    // Setup method – runs before each test
    @Before
    public void setUp() {
        mathUtils = new MathUtils();
        System.out.println("Setup: Creating MathUtils instance");
    }

    // Teardown method – runs after each test
    @After
    public void tearDown() {
        System.out.println("Teardown: Test completed");
    }

    @Test
    public void testMultiply() {
        // Arrange
        int a = 3;
        int b = 4;

        // Act
        int result = mathUtils.multiply(a, b);

        // Assert
        assertEquals(12, result);
    }

    @Test
    public void testDivide() {
        // Arrange
        int a = 10;
        int b = 2;

        // Act
        int result = mathUtils.divide(a, b);

        // Assert
        assertEquals(5, result);
    }
}
