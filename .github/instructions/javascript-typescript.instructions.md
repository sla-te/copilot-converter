---
applyTo: "**/*.{js,ts,jsx,tsx,cjs,mjs}"
---

# Javascript Typescript Guidelines

You are a JavaScript expert specializing in modern JS and async programming.

## Focus Areas

- ES6+ features (destructuring, modules, classes)
- Async patterns (promises, async/await, generators)
- Event loop and microtask queue understanding
- Node.js APIs and performance optimization
- Browser APIs and cross-browser compatibility
- TypeScript migration and type safety

## Approach

1. Prefer async/await over promise chains
2. Use functional patterns where appropriate
3. Handle errors at appropriate boundaries
4. Avoid callback hell with modern patterns
5. Consider bundle size for browser code

## Output

- Modern JavaScript with proper error handling
- Async code with race condition prevention
- Module structure with clean exports
- Jest tests with async test patterns
- Performance profiling results
- Polyfill strategy for browser compatibility

Support both Node.js and browser environments. Include JSDoc comments.

These guidelines provide practices for javascript typescript.

## Javascript Testing Patterns

# JavaScript Testing Patterns

Comprehensive guide for implementing robust testing strategies in JavaScript/TypeScript applications using modern testing frameworks and best practices.

## When to Use This Skill

- Setting up test infrastructure for new projects
- Writing unit tests for functions and classes
- Creating integration tests for APIs and services
- Implementing end-to-end tests for user flows
- Mocking external dependencies and APIs
- Testing React, Vue, or other frontend components
- Implementing test-driven development (TDD)
- Setting up continuous testing in CI/CD pipelines

## Testing Frameworks

### Jest - Full-Featured Testing Framework

**Setup:**

```typescript
// jest.config.ts
import type { Config } from "jest";

const config: Config = {
  preset: "ts-jest",
  testEnvironment: "node",
  roots: ["<rootDir>/src"],
  testMatch: ["**/__tests__/**/*.ts", "**/?(*.)+(spec|test).ts"],
  collectCoverageFrom: [
    "src/**/*.ts",
    "!src/**/*.d.ts",
    "!src/**/*.interface.ts",
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  setupFilesAfterEnv: ["<rootDir>/src/test/setup.ts"],
};

export default config;
```

### Vitest - Fast, Vite-Native Testing

**Setup:**

```typescript
// vitest.config.ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    globals: true,
    environment: "node",
    coverage: {
      provider: "v8",
      reporter: ["text", "json", "html"],
      exclude: ["**/*.d.ts", "**/*.config.ts", "**/dist/**"],
    },
    setupFiles: ["./src/test/setup.ts"],
  },
});
```

## Unit Testing Patterns

### Pattern 1: Testing Pure Functions

```typescript
// utils/calculator.ts
export function add(a: number, b: number): number {
  return a + b;
}

export function divide(a: number, b: number): number {
  if (b === 0) {
    throw new Error("Division by zero");
  }
  return a / b;
}

// utils/calculator.test.ts
import { describe, it, expect } from "vitest";
import { add, divide } from "./calculator";

describe("Calculator", () => {
  describe("add", () => {
    it("should add two positive numbers", () => {
      expect(add(2, 3)).toBe(5);
    });

    it("should add negative numbers", () => {
      expect(add(-2, -3)).toBe(-5);
    });

    it("should handle zero", () => {
      expect(add(0, 5)).toBe(5);
      expect(add(5, 0)).toBe(5);
    });
  });

  describe("divide", () => {
    it("should divide two numbers", () => {
      expect(divide(10, 2)).toBe(5);
    });

    it("should handle decimal results", () => {
      expect(divide(5, 2)).toBe(2.5);
    });

    it("should throw error when dividing by zero", () => {
      expect(() => divide(10, 0)).toThrow("Division by zero");
    });
  });
});
```

### Pattern 2: Testing Classes

```typescript
// services/user.service.ts
export class UserService {
  private users: Map<string, User> = new Map();

  create(user: User): User {
    if (this.users.has(user.id)) {
      throw new Error("User already exists");
    }
    this.users.set(user.id, user);
    return user;
  }

  findById(id: string): User | undefined {
    return this.users.get(id);
  }

  update(id: string, updates: Partial<User>): User {
    const user = this.users.get(id);
    if (!user) {
      throw new Error("User not found");
    }
    const updated = { ...user, ...updates };
    this.users.set(id, updated);
    return updated;
  }

  delete(id: string): boolean {
    return this.users.delete(id);
  }
}

// services/user.service.test.ts
import { describe, it, expect, beforeEach } from "vitest";
import { UserService } from "./user.service";

describe("UserService", () => {
  let service: UserService;

  beforeEach(() => {
    service = new UserService();
  });

  describe("create", () => {
    it("should create a new user", () => {
      const user = { id: "1", name: "John", email: "john@example.com" };
      const created = service.create(user);

      expect(created).toEqual(user);
      expect(service.findById("1")).toEqual(user);
    });

    it("should throw error if user already exists", () => {
      const user = { id: "1", name: "John", email: "john@example.com" };
      service.create(user);

      expect(() => service.create(user)).toThrow("User already exists");
    });
  });

  describe("update", () => {
    it("should update existing user", () => {
      const user = { id: "1", name: "John", email: "john@example.com" };
      service.create(user);

      const updated = service.update("1", { name: "Jane" });

      expect(updated.name).toBe("Jane");
      expect(updated.email).toBe("john@example.com");
    });

    it("should throw error if user not found", () => {
      expect(() => service.update("999", { name: "Jane" })).toThrow(
        "User not found",
      );
    });
  });
});
```

### Pattern 3: Testing Async Functions

```typescript
// services/api.service.ts
export class ApiService {
  async fetchUser(id: string): Promise<User> {
    const response = await fetch(`https://api.example.com/users/${id}`);
    if (!response.ok) {
      throw new Error("User not found");
    }
    return response.json();
  }

  async createUser(user: CreateUserDTO): Promise<User> {
    const response = await fetch("https://api.example.com/users", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(user),
    });
    return response.json();
  }
}

// services/api.service.test.ts
import { describe, it, expect, vi, beforeEach } from "vitest";
import { ApiService } from "./api.service";

// Mock fetch globally
global.fetch = vi.fn();

describe("ApiService", () => {
  let service: ApiService;

  beforeEach(() => {
    service = new ApiService();
    vi.clearAllMocks();
  });

  describe("fetchUser", () => {
    it("should fetch user successfully", async () => {
      const mockUser = { id: "1", name: "John", email: "john@example.com" };

      (fetch as any).mockResolvedValueOnce({
        ok: true,
        json: async () => mockUser,
      });

      const user = await service.fetchUser("1");

      expect(user).toEqual(mockUser);
      expect(fetch).toHaveBeenCalledWith("https://api.example.com/users/1");
    });

    it("should throw error if user not found", async () => {
      (fetch as any).mockResolvedValueOnce({
        ok: false,
      });

      await expect(service.fetchUser("999")).rejects.toThrow("User not found");
    });
  });

  describe("createUser", () => {
    it("should create user successfully", async () => {
      const newUser = { name: "John", email: "john@example.com" };
      const createdUser = { id: "1", ...newUser };

      (fetch as any).mockResolvedValueOnce({
        ok: true,
        json: async () => createdUser,
      });

      const user = await service.createUser(newUser);

      expect(user).toEqual(createdUser);
      expect(fetch).toHaveBeenCalledWith(
        "https://api.example.com/users",
        expect.objectContaining({
          method: "POST",
          body: JSON.stringify(newUser),
        }),
      );
    });
  });
});
```

## Mocking Patterns

### Pattern 1: Mocking Modules

```typescript
// services/email.service.ts
import nodemailer from "nodemailer";

export class EmailService {
  private transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: 587,
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS,
    },
  });

  async sendEmail(to: string, subject: string, html: string) {
    await this.transporter.sendMail({
      from: process.env.EMAIL_FROM,
      to,
      subject,
      html,
    });
  }
}

// services/email.service.test.ts
import { describe, it, expect, vi, beforeEach } from "vitest";
import { EmailService } from "./email.service";

vi.mock("nodemailer", () => ({
  default: {
    createTransport: vi.fn(() => ({
      sendMail: vi.fn().mockResolvedValue({ messageId: "123" }),
    })),
  },
}));

describe("EmailService", () => {
  let service: EmailService;

  beforeEach(() => {
    service = new EmailService();
  });

  it("should send email successfully", async () => {
    await service.sendEmail(
      "test@example.com",
      "Test Subject",
      "<p>Test Body</p>",
    );

    expect(service["transporter"].sendMail).toHaveBeenCalledWith(
      expect.objectContaining({
        to: "test@example.com",
        subject: "Test Subject",
      }),
    );
  });
});
```

### Pattern 2: Dependency Injection for Testing

```typescript
// services/user.service.ts
export interface IUserRepository {
  findById(id: string): Promise<User | null>;
  create(user: User): Promise<User>;
}

export class UserService {
  constructor(private userRepository: IUserRepository) {}

  async getUser(id: string): Promise<User> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new Error("User not found");
    }
    return user;
  }

  async createUser(userData: CreateUserDTO): Promise<User> {
    // Business logic here
    const user = { id: generateId(), ...userData };
    return this.userRepository.create(user);
  }
}

// services/user.service.test.ts
import { describe, it, expect, vi, beforeEach } from "vitest";
import { UserService, IUserRepository } from "./user.service";

describe("UserService", () => {
  let service: UserService;
  let mockRepository: IUserRepository;

  beforeEach(() => {
    mockRepository = {
      findById: vi.fn(),
      create: vi.fn(),
    };
    service = new UserService(mockRepository);
  });

  describe("getUser", () => {
    it("should return user if found", async () => {
      const mockUser = { id: "1", name: "John", email: "john@example.com" };
      vi.mocked(mockRepository.findById).mockResolvedValue(mockUser);

      const user = await service.getUser("1");

      expect(user).toEqual(mockUser);
      expect(mockRepository.findById).toHaveBeenCalledWith("1");
    });

    it("should throw error if user not found", async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(null);

      await expect(service.getUser("999")).rejects.toThrow("User not found");
    });
  });

  describe("createUser", () => {
    it("should create user successfully", async () => {
      const userData = { name: "John", email: "john@example.com" };
      const createdUser = { id: "1", ...userData };

      vi.mocked(mockRepository.create).mockResolvedValue(createdUser);

      const user = await service.createUser(userData);

      expect(user).toEqual(createdUser);
      expect(mockRepository.create).toHaveBeenCalled();
    });
  });
});
```

### Pattern 3: Spying on Functions

```typescript
// utils/logger.ts
export const logger = {
  info: (message: string) => console.log(`INFO: ${message}`),
  error: (message: string) => console.error(`ERROR: ${message}`),
};

// services/order.service.ts
import { logger } from "../utils/logger";

export class OrderService {
  async processOrder(orderId: string): Promise<void> {
    logger.info(`Processing order ${orderId}`);
    // Process order logic
    logger.info(`Order ${orderId} processed successfully`);
  }
}

// services/order.service.test.ts
import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { OrderService } from "./order.service";
import { logger } from "../utils/logger";

describe("OrderService", () => {
  let service: OrderService;
  let loggerSpy: any;

  beforeEach(() => {
    service = new OrderService();
    loggerSpy = vi.spyOn(logger, "info");
  });

  afterEach(() => {
    loggerSpy.mockRestore();
  });

  it("should log order processing", async () => {
    await service.processOrder("123");

    expect(loggerSpy).toHaveBeenCalledWith("Processing order 123");
    expect(loggerSpy).toHaveBeenCalledWith("Order 123 processed successfully");
    expect(loggerSpy).toHaveBeenCalledTimes(2);
  });
});
```

## Integration Testing

### Pattern 1: API Integration Tests

```typescript
// tests/integration/user.api.test.ts
import request from "supertest";
import { app } from "../../src/app";
import { pool } from "../../src/config/database";

describe("User API Integration Tests", () => {
  beforeAll(async () => {
    // Setup test database
    await pool.query("CREATE TABLE IF NOT EXISTS users (...)");
  });

  afterAll(async () => {
    // Cleanup
    await pool.query("DROP TABLE IF EXISTS users");
    await pool.end();
  });

  beforeEach(async () => {
    // Clear data before each test
    await pool.query("TRUNCATE TABLE users CASCADE");
  });

  describe("POST /api/users", () => {
    it("should create a new user", async () => {
      const userData = {
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
      };

      const response = await request(app)
        .post("/api/users")
        .send(userData)
        .expect(201);

      expect(response.body).toMatchObject({
        name: userData.name,
        email: userData.email,
      });
      expect(response.body).toHaveProperty("id");
      expect(response.body).not.toHaveProperty("password");
    });

    it("should return 400 if email is invalid", async () => {
      const userData = {
        name: "John Doe",
        email: "invalid-email",
        password: "password123",
      };

      const response = await request(app)
        .post("/api/users")
        .send(userData)
        .expect(400);

      expect(response.body).toHaveProperty("error");
    });

    it("should return 409 if email already exists", async () => {
      const userData = {
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
      };

      await request(app).post("/api/users").send(userData);

      const response = await request(app)
        .post("/api/users")
        .send(userData)
        .expect(409);

      expect(response.body.error).toContain("already exists");
    });
  });

  describe("GET /api/users/:id", () => {
    it("should get user by id", async () => {
      const createResponse = await request(app).post("/api/users").send({
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
      });

      const userId = createResponse.body.id;

      const response = await request(app)
        .get(`/api/users/${userId}`)
        .expect(200);

      expect(response.body).toMatchObject({
        id: userId,
        name: "John Doe",
        email: "john@example.com",
      });
    });

    it("should return 404 if user not found", async () => {
      await request(app).get("/api/users/999").expect(404);
    });
  });

  describe("Authentication", () => {
    it("should require authentication for protected routes", async () => {
      await request(app).get("/api/users/me").expect(401);
    });

    it("should allow access with valid token", async () => {
      // Create user and login
      await request(app).post("/api/users").send({
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
      });

      const loginResponse = await request(app).post("/api/auth/login").send({
        email: "john@example.com",
        password: "password123",
      });

      const token = loginResponse.body.token;

      const response = await request(app)
        .get("/api/users/me")
        .set("Authorization", `Bearer ${token}`)
        .expect(200);

      expect(response.body.email).toBe("john@example.com");
    });
  });
});
```

### Pattern 2: Database Integration Tests

```typescript
// tests/integration/user.repository.test.ts
import { describe, it, expect, beforeAll, afterAll, beforeEach } from "vitest";
import { Pool } from "pg";
import { UserRepository } from "../../src/repositories/user.repository";

describe("UserRepository Integration Tests", () => {
  let pool: Pool;
  let repository: UserRepository;

  beforeAll(async () => {
    pool = new Pool({
      host: "localhost",
      port: 5432,
      database: "test_db",
      user: "test_user",
      password: "test_password",
    });

    repository = new UserRepository(pool);

    // Create tables
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
  });

  afterAll(async () => {
    await pool.query("DROP TABLE IF EXISTS users");
    await pool.end();
  });

  beforeEach(async () => {
    await pool.query("TRUNCATE TABLE users CASCADE");
  });

  it("should create a user", async () => {
    const user = await repository.create({
      name: "John Doe",
      email: "john@example.com",
      password: "hashed_password",
    });

    expect(user).toHaveProperty("id");
    expect(user.name).toBe("John Doe");
    expect(user.email).toBe("john@example.com");
  });

  it("should find user by email", async () => {
    await repository.create({
      name: "John Doe",
      email: "john@example.com",
      password: "hashed_password",
    });

    const user = await repository.findByEmail("john@example.com");

    expect(user).toBeTruthy();
    expect(user?.name).toBe("John Doe");
  });

  it("should return null if user not found", async () => {
    const user = await repository.findByEmail("nonexistent@example.com");
    expect(user).toBeNull();
  });
});
```

## Frontend Testing with Testing Library

### Pattern 1: React Component Testing

```typescript
// components/UserForm.tsx
import { useState } from 'react';

interface Props {
  onSubmit: (user: { name: string; email: string }) => void;
}

export function UserForm({ onSubmit }: Props) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit({ name, email });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        placeholder="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        data-testid="name-input"
      />
      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        data-testid="email-input"
      />
      <button type="submit">Submit</button>
    </form>
  );
}

// components/UserForm.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { UserForm } from './UserForm';

describe('UserForm', () => {
  it('should render form inputs', () => {
    render(<UserForm onSubmit={vi.fn()} />);

    expect(screen.getByPlaceholderText('Name')).toBeInTheDocument();
    expect(screen.getByPlaceholderText('Email')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Submit' })).toBeInTheDocument();
  });

  it('should update input values', () => {
    render(<UserForm onSubmit={vi.fn()} />);

    const nameInput = screen.getByTestId('name-input') as HTMLInputElement;
    const emailInput = screen.getByTestId('email-input') as HTMLInputElement;

    fireEvent.change(nameInput, { target: { value: 'John Doe' } });
    fireEvent.change(emailInput, { target: { value: 'john@example.com' } });

    expect(nameInput.value).toBe('John Doe');
    expect(emailInput.value).toBe('john@example.com');
  });

  it('should call onSubmit with form data', () => {
    const onSubmit = vi.fn();
    render(<UserForm onSubmit={onSubmit} />);

    fireEvent.change(screen.getByTestId('name-input'), {
      target: { value: 'John Doe' },
    });
    fireEvent.change(screen.getByTestId('email-input'), {
      target: { value: 'john@example.com' },
    });
    fireEvent.click(screen.getByRole('button', { name: 'Submit' }));

    expect(onSubmit).toHaveBeenCalledWith({
      name: 'John Doe',
      email: 'john@example.com',
    });
  });
});
```

### Pattern 2: Testing Hooks

```typescript
// hooks/useCounter.ts
import { useState, useCallback } from "react";

export function useCounter(initialValue = 0) {
  const [count, setCount] = useState(initialValue);

  const increment = useCallback(() => setCount((c) => c + 1), []);
  const decrement = useCallback(() => setCount((c) => c - 1), []);
  const reset = useCallback(() => setCount(initialValue), [initialValue]);

  return { count, increment, decrement, reset };
}

// hooks/useCounter.test.ts
import { renderHook, act } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import { useCounter } from "./useCounter";

describe("useCounter", () => {
  it("should initialize with default value", () => {
    const { result } = renderHook(() => useCounter());
    expect(result.current.count).toBe(0);
  });

  it("should initialize with custom value", () => {
    const { result } = renderHook(() => useCounter(10));
    expect(result.current.count).toBe(10);
  });

  it("should increment count", () => {
    const { result } = renderHook(() => useCounter());

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });

  it("should decrement count", () => {
    const { result } = renderHook(() => useCounter(5));

    act(() => {
      result.current.decrement();
    });

    expect(result.current.count).toBe(4);
  });

  it("should reset to initial value", () => {
    const { result } = renderHook(() => useCounter(10));

    act(() => {
      result.current.increment();
      result.current.increment();
    });

    expect(result.current.count).toBe(12);

    act(() => {
      result.current.reset();
    });

    expect(result.current.count).toBe(10);
  });
});
```

## Test Fixtures and Factories

```typescript
// tests/fixtures/user.fixture.ts
import { faker } from "@faker-js/faker";

export function createUserFixture(overrides?: Partial<User>): User {
  return {
    id: faker.string.uuid(),
    name: faker.person.fullName(),
    email: faker.internet.email(),
    createdAt: faker.date.past(),
    ...overrides,
  };
}

export function createUsersFixture(count: number): User[] {
  return Array.from({ length: count }, () => createUserFixture());
}

// Usage in tests
import {
  createUserFixture,
  createUsersFixture,
} from "../fixtures/user.fixture";

describe("UserService", () => {
  it("should process user", () => {
    const user = createUserFixture({ name: "John Doe" });
    // Use user in test
  });

  it("should handle multiple users", () => {
    const users = createUsersFixture(10);
    // Use users in test
  });
});
```

## Snapshot Testing

```typescript
// components/UserCard.test.tsx
import { render } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { UserCard } from './UserCard';

describe('UserCard', () => {
  it('should match snapshot', () => {
    const user = {
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      avatar: 'https://example.com/avatar.jpg',
    };

    const { container } = render(<UserCard user={user} />);

    expect(container.firstChild).toMatchSnapshot();
  });

  it('should match snapshot with loading state', () => {
    const { container } = render(<UserCard loading />);
    expect(container.firstChild).toMatchSnapshot();
  });
});
```

## Coverage Reports

```typescript
// package.json
{
  "scripts": {
    "test": "vitest",
    "test:coverage": "vitest --coverage",
    "test:ui": "vitest --ui"
  }
}
```

## Best Practices

1. **Follow AAA Pattern**: Arrange, Act, Assert
2. **One assertion per test**: Or logically related assertions
3. **Descriptive test names**: Should describe what is being tested
4. **Use beforeEach/afterEach**: For setup and teardown
5. **Mock external dependencies**: Keep tests isolated
6. **Test edge cases**: Not just happy paths
7. **Avoid implementation details**: Test behavior, not implementation
8. **Use test factories**: For consistent test data
9. **Keep tests fast**: Mock slow operations
10. **Write tests first (TDD)**: When possible
11. **Maintain test coverage**: Aim for 80%+ coverage
12. **Use TypeScript**: For type-safe tests
13. **Test error handling**: Not just success cases
14. **Use data-testid sparingly**: Prefer semantic queries
15. **Clean up after tests**: Prevent test pollution

## Common Patterns

### Test Organization

```typescript
describe("UserService", () => {
  describe("createUser", () => {
    it("should create user successfully", () => {});
    it("should throw error if email exists", () => {});
    it("should hash password", () => {});
  });

  describe("updateUser", () => {
    it("should update user", () => {});
    it("should throw error if not found", () => {});
  });
});
```

### Testing Promises

```typescript
// Using async/await
it("should fetch user", async () => {
  const user = await service.fetchUser("1");
  expect(user).toBeDefined();
});

// Testing rejections
it("should throw error", async () => {
  await expect(service.fetchUser("invalid")).rejects.toThrow("Not found");
});
```

### Testing Timers

```typescript
import { vi } from "vitest";

it("should call function after delay", () => {
  vi.useFakeTimers();

  const callback = vi.fn();
  setTimeout(callback, 1000);

  expect(callback).not.toHaveBeenCalled();

  vi.advanceTimersByTime(1000);

  expect(callback).toHaveBeenCalled();

  vi.useRealTimers();
});
```

## Resources

- **Jest Documentation**: <https://jestjs.io/>
- **Vitest Documentation**: <https://vitest.dev/>
- **Testing Library**: <https://testing-library.com/>
- **Kent C. Dodds Testing Blog**: <https://kentcdodds.com/blog/>

## Modern Javascript Patterns

# Modern JavaScript Patterns

Comprehensive guide for mastering modern JavaScript (ES6+) features, functional programming patterns, and best practices for writing clean, maintainable, and performant code.

## When to Use This Skill

- Refactoring legacy JavaScript to modern syntax
- Implementing functional programming patterns
- Optimizing JavaScript performance
- Writing maintainable and readable code
- Working with asynchronous operations
- Building modern web applications
- Migrating from callbacks to Promises/async-await
- Implementing data transformation pipelines

## ES6+ Core Features

### 1. Arrow Functions

**Syntax and Use Cases:**

```javascript
// Traditional function
function add(a, b) {
  return a + b;
}

// Arrow function
const add = (a, b) => a + b;

// Single parameter (parentheses optional)
const double = (x) => x * 2;

// No parameters
const getRandom = () => Math.random();

// Multiple statements (need curly braces)
const processUser = (user) => {
  const normalized = user.name.toLowerCase();
  return { ...user, name: normalized };
};

// Returning objects (wrap in parentheses)
const createUser = (name, age) => ({ name, age });
```

**Lexical 'this' Binding:**

```javascript
class Counter {
  constructor() {
    this.count = 0;
  }

  // Arrow function preserves 'this' context
  increment = () => {
    this.count++;
  };

  // Traditional function loses 'this' in callbacks
  incrementTraditional() {
    setTimeout(function () {
      this.count++; // 'this' is undefined
    }, 1000);
  }

  // Arrow function maintains 'this'
  incrementArrow() {
    setTimeout(() => {
      this.count++; // 'this' refers to Counter instance
    }, 1000);
  }
}
```

### 2. Destructuring

**Object Destructuring:**

```javascript
const user = {
  id: 1,
  name: "John Doe",
  email: "john@example.com",
  address: {
    city: "New York",
    country: "USA",
  },
};

// Basic destructuring
const { name, email } = user;

// Rename variables
const { name: userName, email: userEmail } = user;

// Default values
const { age = 25 } = user;

// Nested destructuring
const {
  address: { city, country },
} = user;

// Rest operator
const { id, ...userWithoutId } = user;

// Function parameters
function greet({ name, age = 18 }) {
  console.log(`Hello ${name}, you are ${age}`);
}
greet(user);
```

**Array Destructuring:**

```javascript
const numbers = [1, 2, 3, 4, 5];

// Basic destructuring
const [first, second] = numbers;

// Skip elements
const [, , third] = numbers;

// Rest operator
const [head, ...tail] = numbers;

// Swapping variables
let a = 1,
  b = 2;
[a, b] = [b, a];

// Function return values
function getCoordinates() {
  return [10, 20];
}
const [x, y] = getCoordinates();

// Default values
const [one, two, three = 0] = [1, 2];
```

### 3. Spread and Rest Operators

**Spread Operator:**

```javascript
// Array spreading
const arr1 = [1, 2, 3];
const arr2 = [4, 5, 6];
const combined = [...arr1, ...arr2];

// Object spreading
const defaults = { theme: "dark", lang: "en" };
const userPrefs = { theme: "light" };
const settings = { ...defaults, ...userPrefs };

// Function arguments
const numbers = [1, 2, 3];
Math.max(...numbers);

// Copying arrays/objects (shallow copy)
const copy = [...arr1];
const objCopy = { ...user };

// Adding items immutably
const newArr = [...arr1, 4, 5];
const newObj = { ...user, age: 30 };
```

**Rest Parameters:**

```javascript
// Collect function arguments
function sum(...numbers) {
  return numbers.reduce((total, num) => total + num, 0);
}
sum(1, 2, 3, 4, 5);

// With regular parameters
function greet(greeting, ...names) {
  return `${greeting} ${names.join(", ")}`;
}
greet("Hello", "John", "Jane", "Bob");

// Object rest
const { id, ...userData } = user;

// Array rest
const [first, ...rest] = [1, 2, 3, 4, 5];
```

### 4. Template Literals

```javascript
// Basic usage
const name = "John";
const greeting = `Hello, ${name}!`;

// Multi-line strings
const html = `
  <div>
    <h1>${title}</h1>
    <p>${content}</p>
  </div>
`;

// Expression evaluation
const price = 19.99;
const total = `Total: $${(price * 1.2).toFixed(2)}`;

// Tagged template literals
function highlight(strings, ...values) {
  return strings.reduce((result, str, i) => {
    const value = values[i] || "";
    return result + str + `<mark>${value}</mark>`;
  }, "");
}

const name = "John";
const age = 30;
const html = highlight`Name: ${name}, Age: ${age}`;
// Output: "Name: <mark>John</mark>, Age: <mark>30</mark>"
```

### 5. Enhanced Object Literals

```javascript
const name = "John";
const age = 30;

// Shorthand property names
const user = { name, age };

// Shorthand method names
const calculator = {
  add(a, b) {
    return a + b;
  },
  subtract(a, b) {
    return a - b;
  },
};

// Computed property names
const field = "email";
const user = {
  name: "John",
  [field]: "john@example.com",
  [`get${field.charAt(0).toUpperCase()}${field.slice(1)}`]() {
    return this[field];
  },
};

// Dynamic property creation
const createUser = (name, ...props) => {
  return props.reduce(
    (user, [key, value]) => ({
      ...user,
      [key]: value,
    }),
    { name },
  );
};

const user = createUser("John", ["age", 30], ["email", "john@example.com"]);
```

## Asynchronous Patterns

### 1. Promises

**Creating and Using Promises:**

```javascript
// Creating a promise
const fetchUser = (id) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (id > 0) {
        resolve({ id, name: "John" });
      } else {
        reject(new Error("Invalid ID"));
      }
    }, 1000);
  });
};

// Using promises
fetchUser(1)
  .then((user) => console.log(user))
  .catch((error) => console.error(error))
  .finally(() => console.log("Done"));

// Chaining promises
fetchUser(1)
  .then((user) => fetchUserPosts(user.id))
  .then((posts) => processPosts(posts))
  .then((result) => console.log(result))
  .catch((error) => console.error(error));
```

**Promise Combinators:**

```javascript
// Promise.all - Wait for all promises
const promises = [fetchUser(1), fetchUser(2), fetchUser(3)];

Promise.all(promises)
  .then((users) => console.log(users))
  .catch((error) => console.error("At least one failed:", error));

// Promise.allSettled - Wait for all, regardless of outcome
Promise.allSettled(promises).then((results) => {
  results.forEach((result) => {
    if (result.status === "fulfilled") {
      console.log("Success:", result.value);
    } else {
      console.log("Error:", result.reason);
    }
  });
});

// Promise.race - First to complete
Promise.race(promises)
  .then((winner) => console.log("First:", winner))
  .catch((error) => console.error(error));

// Promise.any - First to succeed
Promise.any(promises)
  .then((first) => console.log("First success:", first))
  .catch((error) => console.error("All failed:", error));
```

### 2. Async/Await

**Basic Usage:**

```javascript
// Async function always returns a Promise
async function fetchUser(id) {
  const response = await fetch(`/api/users/${id}`);
  const user = await response.json();
  return user;
}

// Error handling with try/catch
async function getUserData(id) {
  try {
    const user = await fetchUser(id);
    const posts = await fetchUserPosts(user.id);
    return { user, posts };
  } catch (error) {
    console.error("Error fetching data:", error);
    throw error;
  }
}

// Sequential vs Parallel execution
async function sequential() {
  const user1 = await fetchUser(1); // Wait
  const user2 = await fetchUser(2); // Then wait
  return [user1, user2];
}

async function parallel() {
  const [user1, user2] = await Promise.all([fetchUser(1), fetchUser(2)]);
  return [user1, user2];
}
```

**Advanced Patterns:**

```javascript
// Async IIFE
(async () => {
  const result = await someAsyncOperation();
  console.log(result);
})();

// Async iteration
async function processUsers(userIds) {
  for (const id of userIds) {
    const user = await fetchUser(id);
    await processUser(user);
  }
}

// Top-level await (ES2022)
const config = await fetch("/config.json").then((r) => r.json());

// Retry logic
async function fetchWithRetry(url, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      return await fetch(url);
    } catch (error) {
      if (i === retries - 1) throw error;
      await new Promise((resolve) => setTimeout(resolve, 1000 * (i + 1)));
    }
  }
}

// Timeout wrapper
async function withTimeout(promise, ms) {
  const timeout = new Promise((_, reject) =>
    setTimeout(() => reject(new Error("Timeout")), ms),
  );
  return Promise.race([promise, timeout]);
}
```

## Functional Programming Patterns

### 1. Array Methods

**Map, Filter, Reduce:**

```javascript
const users = [
  { id: 1, name: "John", age: 30, active: true },
  { id: 2, name: "Jane", age: 25, active: false },
  { id: 3, name: "Bob", age: 35, active: true },
];

// Map - Transform array
const names = users.map((user) => user.name);
const upperNames = users.map((user) => user.name.toUpperCase());

// Filter - Select elements
const activeUsers = users.filter((user) => user.active);
const adults = users.filter((user) => user.age >= 18);

// Reduce - Aggregate data
const totalAge = users.reduce((sum, user) => sum + user.age, 0);
const avgAge = totalAge / users.length;

// Group by property
const byActive = users.reduce((groups, user) => {
  const key = user.active ? "active" : "inactive";
  return {
    ...groups,
    [key]: [...(groups[key] || []), user],
  };
}, {});

// Chaining methods
const result = users
  .filter((user) => user.active)
  .map((user) => user.name)
  .sort()
  .join(", ");
```

**Advanced Array Methods:**

```javascript
// Find - First matching element
const user = users.find((u) => u.id === 2);

// FindIndex - Index of first match
const index = users.findIndex((u) => u.name === "Jane");

// Some - At least one matches
const hasActive = users.some((u) => u.active);

// Every - All match
const allAdults = users.every((u) => u.age >= 18);

// FlatMap - Map and flatten
const userTags = [
  { name: "John", tags: ["admin", "user"] },
  { name: "Jane", tags: ["user"] },
];
const allTags = userTags.flatMap((u) => u.tags);

// From - Create array from iterable
const str = "hello";
const chars = Array.from(str);
const numbers = Array.from({ length: 5 }, (_, i) => i + 1);

// Of - Create array from arguments
const arr = Array.of(1, 2, 3);
```

### 2. Higher-Order Functions

**Functions as Arguments:**

```javascript
// Custom forEach
function forEach(array, callback) {
  for (let i = 0; i < array.length; i++) {
    callback(array[i], i, array);
  }
}

// Custom map
function map(array, transform) {
  const result = [];
  for (const item of array) {
    result.push(transform(item));
  }
  return result;
}

// Custom filter
function filter(array, predicate) {
  const result = [];
  for (const item of array) {
    if (predicate(item)) {
      result.push(item);
    }
  }
  return result;
}
```

**Functions Returning Functions:**

```javascript
// Currying
const multiply = (a) => (b) => a * b;
const double = multiply(2);
const triple = multiply(3);

console.log(double(5)); // 10
console.log(triple(5)); // 15

// Partial application
function partial(fn, ...args) {
  return (...moreArgs) => fn(...args, ...moreArgs);
}

const add = (a, b, c) => a + b + c;
const add5 = partial(add, 5);
console.log(add5(3, 2)); // 10

// Memoization
function memoize(fn) {
  const cache = new Map();
  return (...args) => {
    const key = JSON.stringify(args);
    if (cache.has(key)) {
      return cache.get(key);
    }
    const result = fn(...args);
    cache.set(key, result);
    return result;
  };
}

const fibonacci = memoize((n) => {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
});
```

### 3. Composition and Piping

```javascript
// Function composition
const compose =
  (...fns) =>
  (x) =>
    fns.reduceRight((acc, fn) => fn(acc), x);

const pipe =
  (...fns) =>
  (x) =>
    fns.reduce((acc, fn) => fn(acc), x);

// Example usage
const addOne = (x) => x + 1;
const double = (x) => x * 2;
const square = (x) => x * x;

const composed = compose(square, double, addOne);
console.log(composed(3)); // ((3 + 1) * 2)^2 = 64

const piped = pipe(addOne, double, square);
console.log(piped(3)); // ((3 + 1) * 2)^2 = 64

// Practical example
const processUser = pipe(
  (user) => ({ ...user, name: user.name.trim() }),
  (user) => ({ ...user, email: user.email.toLowerCase() }),
  (user) => ({ ...user, age: parseInt(user.age) }),
);

const user = processUser({
  name: "  John  ",
  email: "JOHN@EXAMPLE.COM",
  age: "30",
});
```

### 4. Pure Functions and Immutability

```javascript
// Impure function (modifies input)
function addItemImpure(cart, item) {
  cart.items.push(item);
  cart.total += item.price;
  return cart;
}

// Pure function (no side effects)
function addItemPure(cart, item) {
  return {
    ...cart,
    items: [...cart.items, item],
    total: cart.total + item.price,
  };
}

// Immutable array operations
const numbers = [1, 2, 3, 4, 5];

// Add to array
const withSix = [...numbers, 6];

// Remove from array
const withoutThree = numbers.filter((n) => n !== 3);

// Update array element
const doubled = numbers.map((n) => (n === 3 ? n * 2 : n));

// Immutable object operations
const user = { name: "John", age: 30 };

// Update property
const olderUser = { ...user, age: 31 };

// Add property
const withEmail = { ...user, email: "john@example.com" };

// Remove property
const { age, ...withoutAge } = user;

// Deep cloning (simple approach)
const deepClone = (obj) => JSON.parse(JSON.stringify(obj));

// Better deep cloning
const structuredClone = (obj) => globalThis.structuredClone(obj);
```

## Modern Class Features

```javascript
// Class syntax
class User {
  // Private fields
  #password;

  // Public fields
  id;
  name;

  // Static field
  static count = 0;

  constructor(id, name, password) {
    this.id = id;
    this.name = name;
    this.#password = password;
    User.count++;
  }

  // Public method
  greet() {
    return `Hello, ${this.name}`;
  }

  // Private method
  #hashPassword(password) {
    return `hashed_${password}`;
  }

  // Getter
  get displayName() {
    return this.name.toUpperCase();
  }

  // Setter
  set password(newPassword) {
    this.#password = this.#hashPassword(newPassword);
  }

  // Static method
  static create(id, name, password) {
    return new User(id, name, password);
  }
}

// Inheritance
class Admin extends User {
  constructor(id, name, password, role) {
    super(id, name, password);
    this.role = role;
  }

  greet() {
    return `${super.greet()}, I'm an admin`;
  }
}
```

## Modules (ES6)

```javascript
// Exporting
// math.js
export const PI = 3.14159;
export function add(a, b) {
  return a + b;
}
export class Calculator {
  // ...
}

// Default export
export default function multiply(a, b) {
  return a * b;
}

// Importing
// app.js
import multiply, { PI, add, Calculator } from "./math.js";

// Rename imports
import { add as sum } from "./math.js";

// Import all
import * as Math from "./math.js";

// Dynamic imports
const module = await import("./math.js");
const { add } = await import("./math.js");

// Conditional loading
if (condition) {
  const module = await import("./feature.js");
  module.init();
}
```

## Iterators and Generators

```javascript
// Custom iterator
const range = {
  from: 1,
  to: 5,

  [Symbol.iterator]() {
    return {
      current: this.from,
      last: this.to,

      next() {
        if (this.current <= this.last) {
          return { done: false, value: this.current++ };
        } else {
          return { done: true };
        }
      },
    };
  },
};

for (const num of range) {
  console.log(num); // 1, 2, 3, 4, 5
}

// Generator function
function* rangeGenerator(from, to) {
  for (let i = from; i <= to; i++) {
    yield i;
  }
}

for (const num of rangeGenerator(1, 5)) {
  console.log(num);
}

// Infinite generator
function* fibonacci() {
  let [prev, curr] = [0, 1];
  while (true) {
    yield curr;
    [prev, curr] = [curr, prev + curr];
  }
}

// Async generator
async function* fetchPages(url) {
  let page = 1;
  while (true) {
    const response = await fetch(`${url}?page=${page}`);
    const data = await response.json();
    if (data.length === 0) break;
    yield data;
    page++;
  }
}

for await (const page of fetchPages("/api/users")) {
  console.log(page);
}
```

## Modern Operators

```javascript
// Optional chaining
const user = { name: "John", address: { city: "NYC" } };
const city = user?.address?.city;
const zipCode = user?.address?.zipCode; // undefined

// Function call
const result = obj.method?.();

// Array access
const first = arr?.[0];

// Nullish coalescing
const value = null ?? "default"; // 'default'
const value = undefined ?? "default"; // 'default'
const value = 0 ?? "default"; // 0 (not 'default')
const value = "" ?? "default"; // '' (not 'default')

// Logical assignment
let a = null;
a ??= "default"; // a = 'default'

let b = 5;
b ??= 10; // b = 5 (unchanged)

let obj = { count: 0 };
obj.count ||= 1; // obj.count = 1
obj.count &&= 2; // obj.count = 2
```

## Performance Optimization

```javascript
// Debounce
function debounce(fn, delay) {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
}

const searchDebounced = debounce(search, 300);

// Throttle
function throttle(fn, limit) {
  let inThrottle;
  return (...args) => {
    if (!inThrottle) {
      fn(...args);
      inThrottle = true;
      setTimeout(() => (inThrottle = false), limit);
    }
  };
}

const scrollThrottled = throttle(handleScroll, 100);

// Lazy evaluation
function* lazyMap(iterable, transform) {
  for (const item of iterable) {
    yield transform(item);
  }
}

// Use only what you need
const numbers = [1, 2, 3, 4, 5];
const doubled = lazyMap(numbers, (x) => x * 2);
const first = doubled.next().value; // Only computes first value
```

## Best Practices

1. **Use const by default**: Only use let when reassignment is needed
2. **Prefer arrow functions**: Especially for callbacks
3. **Use template literals**: Instead of string concatenation
4. **Destructure objects and arrays**: For cleaner code
5. **Use async/await**: Instead of Promise chains
6. **Avoid mutating data**: Use spread operator and array methods
7. **Use optional chaining**: Prevent "Cannot read property of undefined"
8. **Use nullish coalescing**: For default values
9. **Prefer array methods**: Over traditional loops
10. **Use modules**: For better code organization
11. **Write pure functions**: Easier to test and reason about
12. **Use meaningful variable names**: Self-documenting code
13. **Keep functions small**: Single responsibility principle
14. **Handle errors properly**: Use try/catch with async/await
15. **Use strict mode**: `'use strict'` for better error catching

## Common Pitfalls

1. **this binding confusion**: Use arrow functions or bind()
2. **Async/await without error handling**: Always use try/catch
3. **Promise creation unnecessary**: Don't wrap already async functions
4. **Mutation of objects**: Use spread operator or Object.assign()
5. **Forgetting await**: Async functions return promises
6. **Blocking event loop**: Avoid synchronous operations
7. **Memory leaks**: Clean up event listeners and timers
8. **Not handling promise rejections**: Use catch() or try/catch

## Resources

- **MDN Web Docs**: <https://developer.mozilla.org/en-US/docs/Web/JavaScript>
- **JavaScript.info**: <https://javascript.info/>
- **You Don't Know JS**: <https://github.com/getify/You-Dont-Know-JS>
- **Eloquent JavaScript**: <https://eloquentjavascript.net/>
- **ES6 Features**: <http://es6-features.org/>

## Nodejs Backend Patterns

# Node.js Backend Patterns

Comprehensive guidance for building scalable, maintainable, and production-ready Node.js backend applications with modern frameworks, architectural patterns, and best practices.

## When to Use This Skill

- Building REST APIs or GraphQL servers
- Creating microservices with Node.js
- Implementing authentication and authorization
- Designing scalable backend architectures
- Setting up middleware and error handling
- Integrating databases (SQL and NoSQL)
- Building real-time applications with WebSockets
- Implementing background job processing

## Core Frameworks

### Express.js - Minimalist Framework

**Basic Setup:**

```typescript
import express, { Request, Response, NextFunction } from "express";
import helmet from "helmet";
import cors from "cors";
import compression from "compression";

const app = express();

// Security middleware
app.use(helmet());
app.use(cors({ origin: process.env.ALLOWED_ORIGINS?.split(",") }));
app.use(compression());

// Body parsing
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));

// Request logging
app.use((req: Request, res: Response, next: NextFunction) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### Fastify - High Performance Framework

**Basic Setup:**

```typescript
import Fastify from "fastify";
import helmet from "@fastify/helmet";
import cors from "@fastify/cors";
import compress from "@fastify/compress";

const fastify = Fastify({
  logger: {
    level: process.env.LOG_LEVEL || "info",
    transport: {
      target: "pino-pretty",
      options: { colorize: true },
    },
  },
});

// Plugins
await fastify.register(helmet);
await fastify.register(cors, { origin: true });
await fastify.register(compress);

// Type-safe routes with schema validation
fastify.post<{
  Body: { name: string; email: string };
  Reply: { id: string; name: string };
}>(
  "/users",
  {
    schema: {
      body: {
        type: "object",
        required: ["name", "email"],
        properties: {
          name: { type: "string", minLength: 1 },
          email: { type: "string", format: "email" },
        },
      },
    },
  },
  async (request, reply) => {
    const { name, email } = request.body;
    return { id: "123", name };
  },
);

await fastify.listen({ port: 3000, host: "0.0.0.0" });
```

## Architectural Patterns

### Pattern 1: Layered Architecture

**Structure:**

```
src/
├── controllers/     # Handle HTTP requests/responses
├── services/        # Business logic
├── repositories/    # Data access layer
├── models/          # Data models
├── middleware/      # Express/Fastify middleware
├── routes/          # Route definitions
├── utils/           # Helper functions
├── config/          # Configuration
└── types/           # TypeScript types
```

**Controller Layer:**

```typescript
// controllers/user.controller.ts
import { Request, Response, NextFunction } from "express";
import { UserService } from "../services/user.service";
import { CreateUserDTO, UpdateUserDTO } from "../types/user.types";

export class UserController {
  constructor(private userService: UserService) {}

  async createUser(req: Request, res: Response, next: NextFunction) {
    try {
      const userData: CreateUserDTO = req.body;
      const user = await this.userService.createUser(userData);
      res.status(201).json(user);
    } catch (error) {
      next(error);
    }
  }

  async getUser(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;
      const user = await this.userService.getUserById(id);
      res.json(user);
    } catch (error) {
      next(error);
    }
  }

  async updateUser(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;
      const updates: UpdateUserDTO = req.body;
      const user = await this.userService.updateUser(id, updates);
      res.json(user);
    } catch (error) {
      next(error);
    }
  }

  async deleteUser(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;
      await this.userService.deleteUser(id);
      res.status(204).send();
    } catch (error) {
      next(error);
    }
  }
}
```

**Service Layer:**

```typescript
// services/user.service.ts
import { UserRepository } from "../repositories/user.repository";
import { CreateUserDTO, UpdateUserDTO, User } from "../types/user.types";
import { NotFoundError, ValidationError } from "../utils/errors";
import bcrypt from "bcrypt";

export class UserService {
  constructor(private userRepository: UserRepository) {}

  async createUser(userData: CreateUserDTO): Promise<User> {
    // Validation
    const existingUser = await this.userRepository.findByEmail(userData.email);
    if (existingUser) {
      throw new ValidationError("Email already exists");
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(userData.password, 10);

    // Create user
    const user = await this.userRepository.create({
      ...userData,
      password: hashedPassword,
    });

    // Remove password from response
    const { password, ...userWithoutPassword } = user;
    return userWithoutPassword as User;
  }

  async getUserById(id: string): Promise<User> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new NotFoundError("User not found");
    }
    const { password, ...userWithoutPassword } = user;
    return userWithoutPassword as User;
  }

  async updateUser(id: string, updates: UpdateUserDTO): Promise<User> {
    const user = await this.userRepository.update(id, updates);
    if (!user) {
      throw new NotFoundError("User not found");
    }
    const { password, ...userWithoutPassword } = user;
    return userWithoutPassword as User;
  }

  async deleteUser(id: string): Promise<void> {
    const deleted = await this.userRepository.delete(id);
    if (!deleted) {
      throw new NotFoundError("User not found");
    }
  }
}
```

**Repository Layer:**

```typescript
// repositories/user.repository.ts
import { Pool } from "pg";
import { CreateUserDTO, UpdateUserDTO, UserEntity } from "../types/user.types";

export class UserRepository {
  constructor(private db: Pool) {}

  async create(
    userData: CreateUserDTO & { password: string },
  ): Promise<UserEntity> {
    const query = `
      INSERT INTO users (name, email, password)
      VALUES ($1, $2, $3)
      RETURNING id, name, email, password, created_at, updated_at
    `;
    const { rows } = await this.db.query(query, [
      userData.name,
      userData.email,
      userData.password,
    ]);
    return rows[0];
  }

  async findById(id: string): Promise<UserEntity | null> {
    const query = "SELECT * FROM users WHERE id = $1";
    const { rows } = await this.db.query(query, [id]);
    return rows[0] || null;
  }

  async findByEmail(email: string): Promise<UserEntity | null> {
    const query = "SELECT * FROM users WHERE email = $1";
    const { rows } = await this.db.query(query, [email]);
    return rows[0] || null;
  }

  async update(id: string, updates: UpdateUserDTO): Promise<UserEntity | null> {
    const fields = Object.keys(updates);
    const values = Object.values(updates);

    const setClause = fields
      .map((field, idx) => `${field} = $${idx + 2}`)
      .join(", ");

    const query = `
      UPDATE users
      SET ${setClause}, updated_at = CURRENT_TIMESTAMP
      WHERE id = $1
      RETURNING *
    `;

    const { rows } = await this.db.query(query, [id, ...values]);
    return rows[0] || null;
  }

  async delete(id: string): Promise<boolean> {
    const query = "DELETE FROM users WHERE id = $1";
    const { rowCount } = await this.db.query(query, [id]);
    return rowCount > 0;
  }
}
```

### Pattern 2: Dependency Injection

**DI Container:**

```typescript
// di-container.ts
import { Pool } from "pg";
import { UserRepository } from "./repositories/user.repository";
import { UserService } from "./services/user.service";
import { UserController } from "./controllers/user.controller";
import { AuthService } from "./services/auth.service";

class Container {
  private instances = new Map<string, any>();

  register<T>(key: string, factory: () => T): void {
    this.instances.set(key, factory);
  }

  resolve<T>(key: string): T {
    const factory = this.instances.get(key);
    if (!factory) {
      throw new Error(`No factory registered for ${key}`);
    }
    return factory();
  }

  singleton<T>(key: string, factory: () => T): void {
    let instance: T;
    this.instances.set(key, () => {
      if (!instance) {
        instance = factory();
      }
      return instance;
    });
  }
}

export const container = new Container();

// Register dependencies
container.singleton(
  "db",
  () =>
    new Pool({
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT || "5432"),
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      max: 20,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 2000,
    }),
);

container.singleton(
  "userRepository",
  () => new UserRepository(container.resolve("db")),
);

container.singleton(
  "userService",
  () => new UserService(container.resolve("userRepository")),
);

container.register(
  "userController",
  () => new UserController(container.resolve("userService")),
);

container.singleton(
  "authService",
  () => new AuthService(container.resolve("userRepository")),
);
```

## Middleware Patterns

### Authentication Middleware

```typescript
// middleware/auth.middleware.ts
import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { UnauthorizedError } from "../utils/errors";

interface JWTPayload {
  userId: string;
  email: string;
}

declare global {
  namespace Express {
    interface Request {
      user?: JWTPayload;
    }
  }
}

export const authenticate = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    const token = req.headers.authorization?.replace("Bearer ", "");

    if (!token) {
      throw new UnauthorizedError("No token provided");
    }

    const payload = jwt.verify(token, process.env.JWT_SECRET!) as JWTPayload;

    req.user = payload;
    next();
  } catch (error) {
    next(new UnauthorizedError("Invalid token"));
  }
};

export const authorize = (...roles: string[]) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      return next(new UnauthorizedError("Not authenticated"));
    }

    // Check if user has required role
    const hasRole = roles.some((role) => req.user?.roles?.includes(role));

    if (!hasRole) {
      return next(new UnauthorizedError("Insufficient permissions"));
    }

    next();
  };
};
```

### Validation Middleware

```typescript
// middleware/validation.middleware.ts
import { Request, Response, NextFunction } from "express";
import { AnyZodObject, ZodError } from "zod";
import { ValidationError } from "../utils/errors";

export const validate = (schema: AnyZodObject) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await schema.parseAsync({
        body: req.body,
        query: req.query,
        params: req.params,
      });
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const errors = error.errors.map((err) => ({
          field: err.path.join("."),
          message: err.message,
        }));
        next(new ValidationError("Validation failed", errors));
      } else {
        next(error);
      }
    }
  };
};

// Usage with Zod
import { z } from "zod";

const createUserSchema = z.object({
  body: z.object({
    name: z.string().min(1),
    email: z.string().email(),
    password: z.string().min(8),
  }),
});

router.post("/users", validate(createUserSchema), userController.createUser);
```

### Rate Limiting Middleware

```typescript
// middleware/rate-limit.middleware.ts
import rateLimit from "express-rate-limit";
import RedisStore from "rate-limit-redis";
import Redis from "ioredis";

const redis = new Redis({
  host: process.env.REDIS_HOST,
  port: parseInt(process.env.REDIS_PORT || "6379"),
});

export const apiLimiter = rateLimit({
  store: new RedisStore({
    client: redis,
    prefix: "rl:",
  }),
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: "Too many requests from this IP, please try again later",
  standardHeaders: true,
  legacyHeaders: false,
});

export const authLimiter = rateLimit({
  store: new RedisStore({
    client: redis,
    prefix: "rl:auth:",
  }),
  windowMs: 15 * 60 * 1000,
  max: 5, // Stricter limit for auth endpoints
  skipSuccessfulRequests: true,
});
```

### Request Logging Middleware

```typescript
// middleware/logger.middleware.ts
import { Request, Response, NextFunction } from "express";
import pino from "pino";

const logger = pino({
  level: process.env.LOG_LEVEL || "info",
  transport: {
    target: "pino-pretty",
    options: { colorize: true },
  },
});

export const requestLogger = (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  const start = Date.now();

  // Log response when finished
  res.on("finish", () => {
    const duration = Date.now() - start;
    logger.info({
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration: `${duration}ms`,
      userAgent: req.headers["user-agent"],
      ip: req.ip,
    });
  });

  next();
};

export { logger };
```

## Error Handling

### Custom Error Classes

```typescript
// utils/errors.ts
export class AppError extends Error {
  constructor(
    public message: string,
    public statusCode: number = 500,
    public isOperational: boolean = true,
  ) {
    super(message);
    Object.setPrototypeOf(this, AppError.prototype);
    Error.captureStackTrace(this, this.constructor);
  }
}

export class ValidationError extends AppError {
  constructor(
    message: string,
    public errors?: any[],
  ) {
    super(message, 400);
  }
}

export class NotFoundError extends AppError {
  constructor(message: string = "Resource not found") {
    super(message, 404);
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string = "Unauthorized") {
    super(message, 401);
  }
}

export class ForbiddenError extends AppError {
  constructor(message: string = "Forbidden") {
    super(message, 403);
  }
}

export class ConflictError extends AppError {
  constructor(message: string) {
    super(message, 409);
  }
}
```

### Global Error Handler

```typescript
// middleware/error-handler.ts
import { Request, Response, NextFunction } from "express";
import { AppError } from "../utils/errors";
import { logger } from "./logger.middleware";

export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  if (err instanceof AppError) {
    return res.status(err.statusCode).json({
      status: "error",
      message: err.message,
      ...(err instanceof ValidationError && { errors: err.errors }),
    });
  }

  // Log unexpected errors
  logger.error({
    error: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
  });

  // Don't leak error details in production
  const message =
    process.env.NODE_ENV === "production"
      ? "Internal server error"
      : err.message;

  res.status(500).json({
    status: "error",
    message,
  });
};

// Async error wrapper
export const asyncHandler = (
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>,
) => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};
```

## Database Patterns

### PostgreSQL with Connection Pool

```typescript
// config/database.ts
import { Pool, PoolConfig } from "pg";

const poolConfig: PoolConfig = {
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || "5432"),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
};

export const pool = new Pool(poolConfig);

// Test connection
pool.on("connect", () => {
  console.log("Database connected");
});

pool.on("error", (err) => {
  console.error("Unexpected database error", err);
  process.exit(-1);
});

// Graceful shutdown
export const closeDatabase = async () => {
  await pool.end();
  console.log("Database connection closed");
};
```

### MongoDB with Mongoose

```typescript
// config/mongoose.ts
import mongoose from "mongoose";

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI!, {
      maxPoolSize: 10,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    });

    console.log("MongoDB connected");
  } catch (error) {
    console.error("MongoDB connection error:", error);
    process.exit(1);
  }
};

mongoose.connection.on("disconnected", () => {
  console.log("MongoDB disconnected");
});

mongoose.connection.on("error", (err) => {
  console.error("MongoDB error:", err);
});

export { connectDB };

// Model example
import { Schema, model, Document } from "mongoose";

interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  createdAt: Date;
  updatedAt: Date;
}

const userSchema = new Schema<IUser>(
  {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
  },
  {
    timestamps: true,
  },
);

// Indexes
userSchema.index({ email: 1 });

export const User = model<IUser>("User", userSchema);
```

### Transaction Pattern

```typescript
// services/order.service.ts
import { Pool } from "pg";

export class OrderService {
  constructor(private db: Pool) {}

  async createOrder(userId: string, items: any[]) {
    const client = await this.db.connect();

    try {
      await client.query("BEGIN");

      // Create order
      const orderResult = await client.query(
        "INSERT INTO orders (user_id, total) VALUES ($1, $2) RETURNING id",
        [userId, calculateTotal(items)],
      );
      const orderId = orderResult.rows[0].id;

      // Create order items
      for (const item of items) {
        await client.query(
          "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES ($1, $2, $3, $4)",
          [orderId, item.productId, item.quantity, item.price],
        );

        // Update inventory
        await client.query(
          "UPDATE products SET stock = stock - $1 WHERE id = $2",
          [item.quantity, item.productId],
        );
      }

      await client.query("COMMIT");
      return orderId;
    } catch (error) {
      await client.query("ROLLBACK");
      throw error;
    } finally {
      client.release();
    }
  }
}
```

## Authentication & Authorization

### JWT Authentication

```typescript
// services/auth.service.ts
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
import { UserRepository } from "../repositories/user.repository";
import { UnauthorizedError } from "../utils/errors";

export class AuthService {
  constructor(private userRepository: UserRepository) {}

  async login(email: string, password: string) {
    const user = await this.userRepository.findByEmail(email);

    if (!user) {
      throw new UnauthorizedError("Invalid credentials");
    }

    const isValid = await bcrypt.compare(password, user.password);

    if (!isValid) {
      throw new UnauthorizedError("Invalid credentials");
    }

    const token = this.generateToken({
      userId: user.id,
      email: user.email,
    });

    const refreshToken = this.generateRefreshToken({
      userId: user.id,
    });

    return {
      token,
      refreshToken,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    };
  }

  async refreshToken(refreshToken: string) {
    try {
      const payload = jwt.verify(
        refreshToken,
        process.env.REFRESH_TOKEN_SECRET!,
      ) as { userId: string };

      const user = await this.userRepository.findById(payload.userId);

      if (!user) {
        throw new UnauthorizedError("User not found");
      }

      const token = this.generateToken({
        userId: user.id,
        email: user.email,
      });

      return { token };
    } catch (error) {
      throw new UnauthorizedError("Invalid refresh token");
    }
  }

  private generateToken(payload: any): string {
    return jwt.sign(payload, process.env.JWT_SECRET!, {
      expiresIn: "15m",
    });
  }

  private generateRefreshToken(payload: any): string {
    return jwt.sign(payload, process.env.REFRESH_TOKEN_SECRET!, {
      expiresIn: "7d",
    });
  }
}
```

## Caching Strategies

```typescript
// utils/cache.ts
import Redis from "ioredis";

const redis = new Redis({
  host: process.env.REDIS_HOST,
  port: parseInt(process.env.REDIS_PORT || "6379"),
  retryStrategy: (times) => {
    const delay = Math.min(times * 50, 2000);
    return delay;
  },
});

export class CacheService {
  async get<T>(key: string): Promise<T | null> {
    const data = await redis.get(key);
    return data ? JSON.parse(data) : null;
  }

  async set(key: string, value: any, ttl?: number): Promise<void> {
    const serialized = JSON.stringify(value);
    if (ttl) {
      await redis.setex(key, ttl, serialized);
    } else {
      await redis.set(key, serialized);
    }
  }

  async delete(key: string): Promise<void> {
    await redis.del(key);
  }

  async invalidatePattern(pattern: string): Promise<void> {
    const keys = await redis.keys(pattern);
    if (keys.length > 0) {
      await redis.del(...keys);
    }
  }
}

// Cache decorator
export function Cacheable(ttl: number = 300) {
  return function (
    target: any,
    propertyKey: string,
    descriptor: PropertyDescriptor,
  ) {
    const originalMethod = descriptor.value;

    descriptor.value = async function (...args: any[]) {
      const cache = new CacheService();
      const cacheKey = `${propertyKey}:${JSON.stringify(args)}`;

      const cached = await cache.get(cacheKey);
      if (cached) {
        return cached;
      }

      const result = await originalMethod.apply(this, args);
      await cache.set(cacheKey, result, ttl);

      return result;
    };

    return descriptor;
  };
}
```

## API Response Format

```typescript
// utils/response.ts
import { Response } from "express";

export class ApiResponse {
  static success<T>(
    res: Response,
    data: T,
    message?: string,
    statusCode = 200,
  ) {
    return res.status(statusCode).json({
      status: "success",
      message,
      data,
    });
  }

  static error(res: Response, message: string, statusCode = 500, errors?: any) {
    return res.status(statusCode).json({
      status: "error",
      message,
      ...(errors && { errors }),
    });
  }

  static paginated<T>(
    res: Response,
    data: T[],
    page: number,
    limit: number,
    total: number,
  ) {
    return res.json({
      status: "success",
      data,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit),
      },
    });
  }
}
```

## Best Practices

1. **Use TypeScript**: Type safety prevents runtime errors
2. **Implement proper error handling**: Use custom error classes
3. **Validate input**: Use libraries like Zod or Joi
4. **Use environment variables**: Never hardcode secrets
5. **Implement logging**: Use structured logging (Pino, Winston)
6. **Add rate limiting**: Prevent abuse
7. **Use HTTPS**: Always in production
8. **Implement CORS properly**: Don't use `*` in production
9. **Use dependency injection**: Easier testing and maintenance
10. **Write tests**: Unit, integration, and E2E tests
11. **Handle graceful shutdown**: Clean up resources
12. **Use connection pooling**: For databases
13. **Implement health checks**: For monitoring
14. **Use compression**: Reduce response size
15. **Monitor performance**: Use APM tools

## Testing Patterns

See `javascript-testing-patterns` skill for comprehensive testing guidance.

## Resources

- **Node.js Best Practices**: <https://github.com/goldbergyoni/nodebestpractices>
- **Express.js Guide**: <https://expressjs.com/en/guide/>
- **Fastify Documentation**: <https://www.fastify.io/docs/>
- **TypeScript Node Starter**: <https://github.com/microsoft/TypeScript-Node-Starter>

## Typescript Advanced Types

# TypeScript Advanced Types

Comprehensive guidance for mastering TypeScript's advanced type system including generics, conditional types, mapped types, template literal types, and utility types for building robust, type-safe applications.

## When to Use This Skill

- Building type-safe libraries or frameworks
- Creating reusable generic components
- Implementing complex type inference logic
- Designing type-safe API clients
- Building form validation systems
- Creating strongly-typed configuration objects
- Implementing type-safe state management
- Migrating JavaScript codebases to TypeScript

## Core Concepts

### 1. Generics

**Purpose:** Create reusable, type-flexible components while maintaining type safety.

**Basic Generic Function:**

```typescript
function identity<T>(value: T): T {
  return value;
}

const num = identity<number>(42); // Type: number
const str = identity<string>("hello"); // Type: string
const auto = identity(true); // Type inferred: boolean
```

**Generic Constraints:**

```typescript
interface HasLength {
  length: number;
}

function logLength<T extends HasLength>(item: T): T {
  console.log(item.length);
  return item;
}

logLength("hello"); // OK: string has length
logLength([1, 2, 3]); // OK: array has length
logLength({ length: 10 }); // OK: object has length
// logLength(42);             // Error: number has no length
```

**Multiple Type Parameters:**

```typescript
function merge<T, U>(obj1: T, obj2: U): T & U {
  return { ...obj1, ...obj2 };
}

const merged = merge({ name: "John" }, { age: 30 });
// Type: { name: string } & { age: number }
```

### 2. Conditional Types

**Purpose:** Create types that depend on conditions, enabling sophisticated type logic.

**Basic Conditional Type:**

```typescript
type IsString<T> = T extends string ? true : false;

type A = IsString<string>; // true
type B = IsString<number>; // false
```

**Extracting Return Types:**

```typescript
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never;

function getUser() {
  return { id: 1, name: "John" };
}

type User = ReturnType<typeof getUser>;
// Type: { id: number; name: string; }
```

**Distributive Conditional Types:**

```typescript
type ToArray<T> = T extends any ? T[] : never;

type StrOrNumArray = ToArray<string | number>;
// Type: string[] | number[]
```

**Nested Conditions:**

```typescript
type TypeName<T> = T extends string
  ? "string"
  : T extends number
    ? "number"
    : T extends boolean
      ? "boolean"
      : T extends undefined
        ? "undefined"
        : T extends Function
          ? "function"
          : "object";

type T1 = TypeName<string>; // "string"
type T2 = TypeName<() => void>; // "function"
```

### 3. Mapped Types

**Purpose:** Transform existing types by iterating over their properties.

**Basic Mapped Type:**

```typescript
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};

interface User {
  id: number;
  name: string;
}

type ReadonlyUser = Readonly<User>;
// Type: { readonly id: number; readonly name: string; }
```

**Optional Properties:**

```typescript
type Partial<T> = {
  [P in keyof T]?: T[P];
};

type PartialUser = Partial<User>;
// Type: { id?: number; name?: string; }
```

**Key Remapping:**

```typescript
type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K];
};

interface Person {
  name: string;
  age: number;
}

type PersonGetters = Getters<Person>;
// Type: { getName: () => string; getAge: () => number; }
```

**Filtering Properties:**

```typescript
type PickByType<T, U> = {
  [K in keyof T as T[K] extends U ? K : never]: T[K];
};

interface Mixed {
  id: number;
  name: string;
  age: number;
  active: boolean;
}

type OnlyNumbers = PickByType<Mixed, number>;
// Type: { id: number; age: number; }
```

### 4. Template Literal Types

**Purpose:** Create string-based types with pattern matching and transformation.

**Basic Template Literal:**

```typescript
type EventName = "click" | "focus" | "blur";
type EventHandler = `on${Capitalize<EventName>}`;
// Type: "onClick" | "onFocus" | "onBlur"
```

**String Manipulation:**

```typescript
type UppercaseGreeting = Uppercase<"hello">; // "HELLO"
type LowercaseGreeting = Lowercase<"HELLO">; // "hello"
type CapitalizedName = Capitalize<"john">; // "John"
type UncapitalizedName = Uncapitalize<"John">; // "john"
```

**Path Building:**

```typescript
type Path<T> = T extends object
  ? {
      [K in keyof T]: K extends string ? `${K}` | `${K}.${Path<T[K]>}` : never;
    }[keyof T]
  : never;

interface Config {
  server: {
    host: string;
    port: number;
  };
  database: {
    url: string;
  };
}

type ConfigPath = Path<Config>;
// Type: "server" | "database" | "server.host" | "server.port" | "database.url"
```

### 5. Utility Types

**Built-in Utility Types:**

```typescript
// Partial<T> - Make all properties optional
type PartialUser = Partial<User>;

// Required<T> - Make all properties required
type RequiredUser = Required<PartialUser>;

// Readonly<T> - Make all properties readonly
type ReadonlyUser = Readonly<User>;

// Pick<T, K> - Select specific properties
type UserName = Pick<User, "name" | "email">;

// Omit<T, K> - Remove specific properties
type UserWithoutPassword = Omit<User, "password">;

// Exclude<T, U> - Exclude types from union
type T1 = Exclude<"a" | "b" | "c", "a">; // "b" | "c"

// Extract<T, U> - Extract types from union
type T2 = Extract<"a" | "b" | "c", "a" | "b">; // "a" | "b"

// NonNullable<T> - Exclude null and undefined
type T3 = NonNullable<string | null | undefined>; // string

// Record<K, T> - Create object type with keys K and values T
type PageInfo = Record<"home" | "about", { title: string }>;
```

## Advanced Patterns

### Pattern 1: Type-Safe Event Emitter

```typescript
type EventMap = {
  "user:created": { id: string; name: string };
  "user:updated": { id: string };
  "user:deleted": { id: string };
};

class TypedEventEmitter<T extends Record<string, any>> {
  private listeners: {
    [K in keyof T]?: Array<(data: T[K]) => void>;
  } = {};

  on<K extends keyof T>(event: K, callback: (data: T[K]) => void): void {
    if (!this.listeners[event]) {
      this.listeners[event] = [];
    }
    this.listeners[event]!.push(callback);
  }

  emit<K extends keyof T>(event: K, data: T[K]): void {
    const callbacks = this.listeners[event];
    if (callbacks) {
      callbacks.forEach((callback) => callback(data));
    }
  }
}

const emitter = new TypedEventEmitter<EventMap>();

emitter.on("user:created", (data) => {
  console.log(data.id, data.name); // Type-safe!
});

emitter.emit("user:created", { id: "1", name: "John" });
// emitter.emit("user:created", { id: "1" });  // Error: missing 'name'
```

### Pattern 2: Type-Safe API Client

```typescript
type HTTPMethod = "GET" | "POST" | "PUT" | "DELETE";

type EndpointConfig = {
  "/users": {
    GET: { response: User[] };
    POST: { body: { name: string; email: string }; response: User };
  };
  "/users/:id": {
    GET: { params: { id: string }; response: User };
    PUT: { params: { id: string }; body: Partial<User>; response: User };
    DELETE: { params: { id: string }; response: void };
  };
};

type ExtractParams<T> = T extends { params: infer P } ? P : never;
type ExtractBody<T> = T extends { body: infer B } ? B : never;
type ExtractResponse<T> = T extends { response: infer R } ? R : never;

class APIClient<Config extends Record<string, Record<HTTPMethod, any>>> {
  async request<Path extends keyof Config, Method extends keyof Config[Path]>(
    path: Path,
    method: Method,
    ...[options]: ExtractParams<Config[Path][Method]> extends never
      ? ExtractBody<Config[Path][Method]> extends never
        ? []
        : [{ body: ExtractBody<Config[Path][Method]> }]
      : [
          {
            params: ExtractParams<Config[Path][Method]>;
            body?: ExtractBody<Config[Path][Method]>;
          },
        ]
  ): Promise<ExtractResponse<Config[Path][Method]>> {
    // Implementation here
    return {} as any;
  }
}

const api = new APIClient<EndpointConfig>();

// Type-safe API calls
const users = await api.request("/users", "GET");
// Type: User[]

const newUser = await api.request("/users", "POST", {
  body: { name: "John", email: "john@example.com" },
});
// Type: User

const user = await api.request("/users/:id", "GET", {
  params: { id: "123" },
});
// Type: User
```

### Pattern 3: Builder Pattern with Type Safety

```typescript
type BuilderState<T> = {
  [K in keyof T]: T[K] | undefined;
};

type RequiredKeys<T> = {
  [K in keyof T]-?: {} extends Pick<T, K> ? never : K;
}[keyof T];

type OptionalKeys<T> = {
  [K in keyof T]-?: {} extends Pick<T, K> ? K : never;
}[keyof T];

type IsComplete<T, S> =
  RequiredKeys<T> extends keyof S
    ? S[RequiredKeys<T>] extends undefined
      ? false
      : true
    : false;

class Builder<T, S extends BuilderState<T> = {}> {
  private state: S = {} as S;

  set<K extends keyof T>(key: K, value: T[K]): Builder<T, S & Record<K, T[K]>> {
    this.state[key] = value;
    return this as any;
  }

  build(this: IsComplete<T, S> extends true ? this : never): T {
    return this.state as T;
  }
}

interface User {
  id: string;
  name: string;
  email: string;
  age?: number;
}

const builder = new Builder<User>();

const user = builder
  .set("id", "1")
  .set("name", "John")
  .set("email", "john@example.com")
  .build(); // OK: all required fields set

// const incomplete = builder
//   .set("id", "1")
//   .build();  // Error: missing required fields
```

### Pattern 4: Deep Readonly/Partial

```typescript
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends object
    ? T[P] extends Function
      ? T[P]
      : DeepReadonly<T[P]>
    : T[P];
};

type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object
    ? T[P] extends Array<infer U>
      ? Array<DeepPartial<U>>
      : DeepPartial<T[P]>
    : T[P];
};

interface Config {
  server: {
    host: string;
    port: number;
    ssl: {
      enabled: boolean;
      cert: string;
    };
  };
  database: {
    url: string;
    pool: {
      min: number;
      max: number;
    };
  };
}

type ReadonlyConfig = DeepReadonly<Config>;
// All nested properties are readonly

type PartialConfig = DeepPartial<Config>;
// All nested properties are optional
```

### Pattern 5: Type-Safe Form Validation

```typescript
type ValidationRule<T> = {
  validate: (value: T) => boolean;
  message: string;
};

type FieldValidation<T> = {
  [K in keyof T]?: ValidationRule<T[K]>[];
};

type ValidationErrors<T> = {
  [K in keyof T]?: string[];
};

class FormValidator<T extends Record<string, any>> {
  constructor(private rules: FieldValidation<T>) {}

  validate(data: T): ValidationErrors<T> | null {
    const errors: ValidationErrors<T> = {};
    let hasErrors = false;

    for (const key in this.rules) {
      const fieldRules = this.rules[key];
      const value = data[key];

      if (fieldRules) {
        const fieldErrors: string[] = [];

        for (const rule of fieldRules) {
          if (!rule.validate(value)) {
            fieldErrors.push(rule.message);
          }
        }

        if (fieldErrors.length > 0) {
          errors[key] = fieldErrors;
          hasErrors = true;
        }
      }
    }

    return hasErrors ? errors : null;
  }
}

interface LoginForm {
  email: string;
  password: string;
}

const validator = new FormValidator<LoginForm>({
  email: [
    {
      validate: (v) => v.includes("@"),
      message: "Email must contain @",
    },
    {
      validate: (v) => v.length > 0,
      message: "Email is required",
    },
  ],
  password: [
    {
      validate: (v) => v.length >= 8,
      message: "Password must be at least 8 characters",
    },
  ],
});

const errors = validator.validate({
  email: "invalid",
  password: "short",
});
// Type: { email?: string[]; password?: string[]; } | null
```

### Pattern 6: Discriminated Unions

```typescript
type Success<T> = {
  status: "success";
  data: T;
};

type Error = {
  status: "error";
  error: string;
};

type Loading = {
  status: "loading";
};

type AsyncState<T> = Success<T> | Error | Loading;

function handleState<T>(state: AsyncState<T>): void {
  switch (state.status) {
    case "success":
      console.log(state.data); // Type: T
      break;
    case "error":
      console.log(state.error); // Type: string
      break;
    case "loading":
      console.log("Loading...");
      break;
  }
}

// Type-safe state machine
type State =
  | { type: "idle" }
  | { type: "fetching"; requestId: string }
  | { type: "success"; data: any }
  | { type: "error"; error: Error };

type Event =
  | { type: "FETCH"; requestId: string }
  | { type: "SUCCESS"; data: any }
  | { type: "ERROR"; error: Error }
  | { type: "RESET" };

function reducer(state: State, event: Event): State {
  switch (state.type) {
    case "idle":
      return event.type === "FETCH"
        ? { type: "fetching", requestId: event.requestId }
        : state;
    case "fetching":
      if (event.type === "SUCCESS") {
        return { type: "success", data: event.data };
      }
      if (event.type === "ERROR") {
        return { type: "error", error: event.error };
      }
      return state;
    case "success":
    case "error":
      return event.type === "RESET" ? { type: "idle" } : state;
  }
}
```

## Type Inference Techniques

### 1. Infer Keyword

```typescript
// Extract array element type
type ElementType<T> = T extends (infer U)[] ? U : never;

type NumArray = number[];
type Num = ElementType<NumArray>; // number

// Extract promise type
type PromiseType<T> = T extends Promise<infer U> ? U : never;

type AsyncNum = PromiseType<Promise<number>>; // number

// Extract function parameters
type Parameters<T> = T extends (...args: infer P) => any ? P : never;

function foo(a: string, b: number) {}
type FooParams = Parameters<typeof foo>; // [string, number]
```

### 2. Type Guards

```typescript
function isString(value: unknown): value is string {
  return typeof value === "string";
}

function isArrayOf<T>(
  value: unknown,
  guard: (item: unknown) => item is T,
): value is T[] {
  return Array.isArray(value) && value.every(guard);
}

const data: unknown = ["a", "b", "c"];

if (isArrayOf(data, isString)) {
  data.forEach((s) => s.toUpperCase()); // Type: string[]
}
```

### 3. Assertion Functions

```typescript
function assertIsString(value: unknown): asserts value is string {
  if (typeof value !== "string") {
    throw new Error("Not a string");
  }
}

function processValue(value: unknown) {
  assertIsString(value);
  // value is now typed as string
  console.log(value.toUpperCase());
}
```

## Best Practices

1. **Use `unknown` over `any`**: Enforce type checking
2. **Prefer `interface` for object shapes**: Better error messages
3. **Use `type` for unions and complex types**: More flexible
4. **Leverage type inference**: Let TypeScript infer when possible
5. **Create helper types**: Build reusable type utilities
6. **Use const assertions**: Preserve literal types
7. **Avoid type assertions**: Use type guards instead
8. **Document complex types**: Add JSDoc comments
9. **Use strict mode**: Enable all strict compiler options
10. **Test your types**: Use type tests to verify type behavior

## Type Testing

```typescript
// Type assertion tests
type AssertEqual<T, U> = [T] extends [U]
  ? [U] extends [T]
    ? true
    : false
  : false;

type Test1 = AssertEqual<string, string>; // true
type Test2 = AssertEqual<string, number>; // false
type Test3 = AssertEqual<string | number, string>; // false

// Expect error helper
type ExpectError<T extends never> = T;

// Example usage
type ShouldError = ExpectError<AssertEqual<string, number>>;
```

## Common Pitfalls

1. **Over-using `any`**: Defeats the purpose of TypeScript
2. **Ignoring strict null checks**: Can lead to runtime errors
3. **Too complex types**: Can slow down compilation
4. **Not using discriminated unions**: Misses type narrowing opportunities
5. **Forgetting readonly modifiers**: Allows unintended mutations
6. **Circular type references**: Can cause compiler errors
7. **Not handling edge cases**: Like empty arrays or null values

## Performance Considerations

- Avoid deeply nested conditional types
- Use simple types when possible
- Cache complex type computations
- Limit recursion depth in recursive types
- Use build tools to skip type checking in production

## Resources

- **TypeScript Handbook**: <https://www.typescriptlang.org/docs/handbook/>
- **Type Challenges**: <https://github.com/type-challenges/type-challenges>
- **TypeScript Deep Dive**: <https://basarat.gitbook.io/typescript/>
- **Effective TypeScript**: Book by Dan Vanderkam
