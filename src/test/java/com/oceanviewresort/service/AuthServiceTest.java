package com.oceanviewresort.service;

import com.oceanviewresort.dao.UserDAO;
import com.oceanviewresort.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class AuthServiceTest {

    private UserDAO userDAO;
    private AuthService authService;

    @BeforeEach
    void setUp() {
        userDAO = mock(UserDAO.class);
        authService = new AuthService(userDAO);
    }

    @Test
    void shouldLoginSuccessfullyWhenCredentialsAreCorrect() {

        User user = new User();
        user.setUsername("admin");
        user.setPasswordHash("admin123");

        when(userDAO.findByUsername("admin")).thenReturn(user);

        User result = authService.login("admin", "admin123");

        assertNotNull(result);
        assertEquals("admin", result.getUsername());
    }

    @Test
    void shouldReturnNullWhenUsernameIsEmpty() {

        User result = authService.login("", "admin123");

        assertNull(result);
    }

    @Test
    void shouldReturnNullWhenPasswordIsEmpty() {

        User result = authService.login("admin", "");

        assertNull(result);
    }

    @Test
    void shouldReturnNullWhenUserDoesNotExist() {

        when(userDAO.findByUsername("unknown")).thenReturn(null);

        User result = authService.login("unknown", "123");

        assertNull(result);
    }

    @Test
    void shouldReturnNullWhenPasswordIsIncorrect() {

        User user = new User();
        user.setUsername("admin");
        user.setPasswordHash("correct123");

        when(userDAO.findByUsername("admin")).thenReturn(user);

        User result = authService.login("admin", "wrong");

        assertNull(result);
    }
}