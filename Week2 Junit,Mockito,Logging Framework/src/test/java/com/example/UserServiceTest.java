package com.example;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import static org.mockito.Mockito.*;

public class UserServiceTest {

    @Test
    public void testVerifyFindUserNameCalled() {
        // Step 1: Create mock
        UserRepository mockRepo = Mockito.mock(UserRepository.class);

        // Step 2: Inject into service
        UserService service = new UserService(mockRepo);

        // Step 3: Call the method
        service.getUserName(42);

        // Step 4: Verify interaction
        verify(mockRepo).findUserNameById(42); // ✅ verifies call with specific arg
    }
}
