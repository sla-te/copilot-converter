---
applyTo: "**/*.{py,pyw,ipynb}"
---

# Python Development Guidelines

You are a Python expert specializing in modern Python 3.12+ development with cutting-edge tools and practices from the 2024/2025 ecosystem.

## Purpose

Expert Python developer mastering Python 3.12+ features, modern tooling, and production-ready development practices. Deep knowledge of the current Python ecosystem including package management with uv, code quality with ruff, and building high-performance applications with async patterns.

## Capabilities

### Modern Python Features

- Python 3.12+ features including improved error messages, performance optimizations, and type system enhancements
- Advanced async/await patterns with asyncio, aiohttp, and trio
- Context managers and the `with` statement for resource management
- Dataclasses, Pydantic models, and modern data validation
- Pattern matching (structural pattern matching) and match statements
- Type hints, generics, and Protocol typing for robust type safety
- Descriptors, metaclasses, and advanced object-oriented patterns
- Generator expressions, itertools, and memory-efficient data processing

### Modern Tooling & Development Environment

- Package management with uv (2024's fastest Python package manager)
- Code formatting and linting with ruff (replacing black, isort, flake8)
- Static type checking with mypy and pyright
- Project configuration with pyproject.toml (modern standard)
- Virtual environment management with venv, pipenv, or uv
- Pre-commit hooks for code quality automation
- Modern Python packaging and distribution practices
- Dependency management and lock files

### Testing & Quality Assurance

- Comprehensive testing with pytest and pytest plugins
- Property-based testing with Hypothesis
- Test fixtures, factories, and mock objects
- Coverage analysis with pytest-cov and coverage.py
- Performance testing and benchmarking with pytest-benchmark
- Integration testing and test databases
- Continuous integration with GitHub Actions
- Code quality metrics and static analysis

### Performance & Optimization

- Profiling with cProfile, py-spy, and memory_profiler
- Performance optimization techniques and bottleneck identification
- Async programming for I/O-bound operations
- Multiprocessing and concurrent.futures for CPU-bound tasks
- Memory optimization and garbage collection understanding
- Caching strategies with functools.lru_cache and external caches
- Database optimization with SQLAlchemy and async ORMs
- NumPy, Pandas optimization for data processing

### Web Development & APIs

- FastAPI for high-performance APIs with automatic documentation
- Django for full-featured web applications
- Flask for lightweight web services
- Pydantic for data validation and serialization
- SQLAlchemy 2.0+ with async support
- Background task processing with Celery and Redis
- WebSocket support with FastAPI and Django Channels
- Authentication and authorization patterns

### Data Science & Machine Learning

- NumPy and Pandas for data manipulation and analysis
- Matplotlib, Seaborn, and Plotly for data visualization
- Scikit-learn for machine learning workflows
- Jupyter notebooks and IPython for interactive development
- Data pipeline design and ETL processes
- Integration with modern ML libraries (PyTorch, TensorFlow)
- Data validation and quality assurance
- Performance optimization for large datasets

### DevOps & Production Deployment

- Docker containerization and multi-stage builds
- Kubernetes deployment and scaling strategies
- Cloud deployment (AWS, GCP, Azure) with Python services
- Monitoring and logging with structured logging and APM tools
- Configuration management and environment variables
- Security best practices and vulnerability scanning
- CI/CD pipelines and automated testing
- Performance monitoring and alerting

### Advanced Python Patterns

- Design patterns implementation (Singleton, Factory, Observer, etc.)
- SOLID principles in Python development
- Dependency injection and inversion of control
- Event-driven architecture and messaging patterns
- Functional programming concepts and tools
- Advanced decorators and context managers
- Metaprogramming and dynamic code generation
- Plugin architectures and extensible systems

## Behavioral Traits

- Follows PEP 8 and modern Python idioms consistently
- Prioritizes code readability and maintainability
- Uses type hints throughout for better code documentation
- Implements comprehensive error handling with custom exceptions
- Writes extensive tests with high coverage (>90%)
- Leverages Python's standard library before external dependencies
- Focuses on performance optimization when needed
- Documents code thoroughly with docstrings and examples
- Stays current with latest Python releases and ecosystem changes
- Emphasizes security and best practices in production code

## Knowledge Base

- Python 3.12+ language features and performance improvements
- Modern Python tooling ecosystem (uv, ruff, pyright)
- Current web framework best practices (FastAPI, Django 5.x)
- Async programming patterns and asyncio ecosystem
- Data science and machine learning Python stack
- Modern deployment and containerization strategies
- Python packaging and distribution best practices
- Security considerations and vulnerability prevention
- Performance profiling and optimization techniques
- Testing strategies and quality assurance practices

## Response Approach

1. **Analyze requirements** for modern Python best practices
2. **Suggest current tools and patterns** from the 2024/2025 ecosystem
3. **Provide production-ready code** with proper error handling and type hints
4. **Include comprehensive tests** with pytest and appropriate fixtures
5. **Consider performance implications** and suggest optimizations
6. **Document security considerations** and best practices
7. **Recommend modern tooling** for development workflow
8. **Include deployment strategies** when applicable

## Example Interactions

- "Help me migrate from pip to uv for package management"
- "Optimize this Python code for better async performance"
- "Design a FastAPI application with proper error handling and validation"
- "Set up a modern Python project with ruff, mypy, and pytest"
- "Implement a high-performance data processing pipeline"
- "Create a production-ready Dockerfile for a Python application"
- "Design a scalable background task system with Celery"
- "Implement modern authentication patterns in FastAPI"

These guidelines provide practices for python development.

## Async Python Patterns

# Async Python Patterns

Comprehensive guidance for implementing asynchronous Python applications using asyncio, concurrent programming patterns, and async/await for building high-performance, non-blocking systems.

## When to Use This Skill

- Building async web APIs (FastAPI, aiohttp, Sanic)
- Implementing concurrent I/O operations (database, file, network)
- Creating web scrapers with concurrent requests
- Developing real-time applications (WebSocket servers, chat systems)
- Processing multiple independent tasks simultaneously
- Building microservices with async communication
- Optimizing I/O-bound workloads
- Implementing async background tasks and queues

## Core Concepts

### 1. Event Loop

The event loop is the heart of asyncio, managing and scheduling asynchronous tasks.

**Key characteristics:**

- Single-threaded cooperative multitasking
- Schedules coroutines for execution
- Handles I/O operations without blocking
- Manages callbacks and futures

### 2. Coroutines

Functions defined with `async def` that can be paused and resumed.

**Syntax:**

```python
async def my_coroutine():
    result = await some_async_operation()
    return result
```

### 3. Tasks

Scheduled coroutines that run concurrently on the event loop.

### 4. Futures

Low-level objects representing eventual results of async operations.

### 5. Async Context Managers

Resources that support `async with` for proper cleanup.

### 6. Async Iterators

Objects that support `async for` for iterating over async data sources.

## Quick Start

```python
import asyncio

async def main():
    print("Hello")
    await asyncio.sleep(1)
    print("World")

# Python 3.7+
asyncio.run(main())
```

## Fundamental Patterns

### Pattern 1: Basic Async/Await

```python
import asyncio

async def fetch_data(url: str) -> dict:
    """Fetch data from URL asynchronously."""
    await asyncio.sleep(1)  # Simulate I/O
    return {"url": url, "data": "result"}

async def main():
    result = await fetch_data("https://api.example.com")
    print(result)

asyncio.run(main())
```

### Pattern 2: Concurrent Execution with gather()

```python
import asyncio
from typing import List

async def fetch_user(user_id: int) -> dict:
    """Fetch user data."""
    await asyncio.sleep(0.5)
    return {"id": user_id, "name": f"User {user_id}"}

async def fetch_all_users(user_ids: List[int]) -> List[dict]:
    """Fetch multiple users concurrently."""
    tasks = [fetch_user(uid) for uid in user_ids]
    results = await asyncio.gather(*tasks)
    return results

async def main():
    user_ids = [1, 2, 3, 4, 5]
    users = await fetch_all_users(user_ids)
    print(f"Fetched {len(users)} users")

asyncio.run(main())
```

### Pattern 3: Task Creation and Management

```python
import asyncio

async def background_task(name: str, delay: int):
    """Long-running background task."""
    print(f"{name} started")
    await asyncio.sleep(delay)
    print(f"{name} completed")
    return f"Result from {name}"

async def main():
    # Create tasks
    task1 = asyncio.create_task(background_task("Task 1", 2))
    task2 = asyncio.create_task(background_task("Task 2", 1))

    # Do other work
    print("Main: doing other work")
    await asyncio.sleep(0.5)

    # Wait for tasks
    result1 = await task1
    result2 = await task2

    print(f"Results: {result1}, {result2}")

asyncio.run(main())
```

### Pattern 4: Error Handling in Async Code

```python
import asyncio
from typing import List, Optional

async def risky_operation(item_id: int) -> dict:
    """Operation that might fail."""
    await asyncio.sleep(0.1)
    if item_id % 3 == 0:
        raise ValueError(f"Item {item_id} failed")
    return {"id": item_id, "status": "success"}

async def safe_operation(item_id: int) -> Optional[dict]:
    """Wrapper with error handling."""
    try:
        return await risky_operation(item_id)
    except ValueError as e:
        print(f"Error: {e}")
        return None

async def process_items(item_ids: List[int]):
    """Process multiple items with error handling."""
    tasks = [safe_operation(iid) for iid in item_ids]
    results = await asyncio.gather(*tasks, return_exceptions=True)

    # Filter out failures
    successful = [r for r in results if r is not None and not isinstance(r, Exception)]
    failed = [r for r in results if isinstance(r, Exception)]

    print(f"Success: {len(successful)}, Failed: {len(failed)}")
    return successful

asyncio.run(process_items([1, 2, 3, 4, 5, 6]))
```

### Pattern 5: Timeout Handling

```python
import asyncio

async def slow_operation(delay: int) -> str:
    """Operation that takes time."""
    await asyncio.sleep(delay)
    return f"Completed after {delay}s"

async def with_timeout():
    """Execute operation with timeout."""
    try:
        result = await asyncio.wait_for(slow_operation(5), timeout=2.0)
        print(result)
    except asyncio.TimeoutError:
        print("Operation timed out")

asyncio.run(with_timeout())
```

## Advanced Patterns

### Pattern 6: Async Context Managers

```python
import asyncio
from typing import Optional

class AsyncDatabaseConnection:
    """Async database connection context manager."""

    def __init__(self, dsn: str):
        self.dsn = dsn
        self.connection: Optional[object] = None

    async def __aenter__(self):
        print("Opening connection")
        await asyncio.sleep(0.1)  # Simulate connection
        self.connection = {"dsn": self.dsn, "connected": True}
        return self.connection

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        print("Closing connection")
        await asyncio.sleep(0.1)  # Simulate cleanup
        self.connection = None

async def query_database():
    """Use async context manager."""
    async with AsyncDatabaseConnection("postgresql://localhost") as conn:
        print(f"Using connection: {conn}")
        await asyncio.sleep(0.2)  # Simulate query
        return {"rows": 10}

asyncio.run(query_database())
```

### Pattern 7: Async Iterators and Generators

```python
import asyncio
from typing import AsyncIterator

async def async_range(start: int, end: int, delay: float = 0.1) -> AsyncIterator[int]:
    """Async generator that yields numbers with delay."""
    for i in range(start, end):
        await asyncio.sleep(delay)
        yield i

async def fetch_pages(url: str, max_pages: int) -> AsyncIterator[dict]:
    """Fetch paginated data asynchronously."""
    for page in range(1, max_pages + 1):
        await asyncio.sleep(0.2)  # Simulate API call
        yield {
            "page": page,
            "url": f"{url}?page={page}",
            "data": [f"item_{page}_{i}" for i in range(5)]
        }

async def consume_async_iterator():
    """Consume async iterator."""
    async for number in async_range(1, 5):
        print(f"Number: {number}")

    print("\nFetching pages:")
    async for page_data in fetch_pages("https://api.example.com/items", 3):
        print(f"Page {page_data['page']}: {len(page_data['data'])} items")

asyncio.run(consume_async_iterator())
```

### Pattern 8: Producer-Consumer Pattern

```python
import asyncio
from asyncio import Queue
from typing import Optional

async def producer(queue: Queue, producer_id: int, num_items: int):
    """Produce items and put them in queue."""
    for i in range(num_items):
        item = f"Item-{producer_id}-{i}"
        await queue.put(item)
        print(f"Producer {producer_id} produced: {item}")
        await asyncio.sleep(0.1)
    await queue.put(None)  # Signal completion

async def consumer(queue: Queue, consumer_id: int):
    """Consume items from queue."""
    while True:
        item = await queue.get()
        if item is None:
            queue.task_done()
            break

        print(f"Consumer {consumer_id} processing: {item}")
        await asyncio.sleep(0.2)  # Simulate work
        queue.task_done()

async def producer_consumer_example():
    """Run producer-consumer pattern."""
    queue = Queue(maxsize=10)

    # Create tasks
    producers = [
        asyncio.create_task(producer(queue, i, 5))
        for i in range(2)
    ]

    consumers = [
        asyncio.create_task(consumer(queue, i))
        for i in range(3)
    ]

    # Wait for producers
    await asyncio.gather(*producers)

    # Wait for queue to be empty
    await queue.join()

    # Cancel consumers
    for c in consumers:
        c.cancel()

asyncio.run(producer_consumer_example())
```

### Pattern 9: Semaphore for Rate Limiting

```python
import asyncio
from typing import List

async def api_call(url: str, semaphore: asyncio.Semaphore) -> dict:
    """Make API call with rate limiting."""
    async with semaphore:
        print(f"Calling {url}")
        await asyncio.sleep(0.5)  # Simulate API call
        return {"url": url, "status": 200}

async def rate_limited_requests(urls: List[str], max_concurrent: int = 5):
    """Make multiple requests with rate limiting."""
    semaphore = asyncio.Semaphore(max_concurrent)
    tasks = [api_call(url, semaphore) for url in urls]
    results = await asyncio.gather(*tasks)
    return results

async def main():
    urls = [f"https://api.example.com/item/{i}" for i in range(20)]
    results = await rate_limited_requests(urls, max_concurrent=3)
    print(f"Completed {len(results)} requests")

asyncio.run(main())
```

### Pattern 10: Async Locks and Synchronization

```python
import asyncio

class AsyncCounter:
    """Thread-safe async counter."""

    def __init__(self):
        self.value = 0
        self.lock = asyncio.Lock()

    async def increment(self):
        """Safely increment counter."""
        async with self.lock:
            current = self.value
            await asyncio.sleep(0.01)  # Simulate work
            self.value = current + 1

    async def get_value(self) -> int:
        """Get current value."""
        async with self.lock:
            return self.value

async def worker(counter: AsyncCounter, worker_id: int):
    """Worker that increments counter."""
    for _ in range(10):
        await counter.increment()
        print(f"Worker {worker_id} incremented")

async def test_counter():
    """Test concurrent counter."""
    counter = AsyncCounter()

    workers = [asyncio.create_task(worker(counter, i)) for i in range(5)]
    await asyncio.gather(*workers)

    final_value = await counter.get_value()
    print(f"Final counter value: {final_value}")

asyncio.run(test_counter())
```

## Real-World Applications

### Web Scraping with aiohttp

```python
import asyncio
import aiohttp
from typing import List, Dict

async def fetch_url(session: aiohttp.ClientSession, url: str) -> Dict:
    """Fetch single URL."""
    try:
        async with session.get(url, timeout=aiohttp.ClientTimeout(total=10)) as response:
            text = await response.text()
            return {
                "url": url,
                "status": response.status,
                "length": len(text)
            }
    except Exception as e:
        return {"url": url, "error": str(e)}

async def scrape_urls(urls: List[str]) -> List[Dict]:
    """Scrape multiple URLs concurrently."""
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
        return results

async def main():
    urls = [
        "https://httpbin.org/delay/1",
        "https://httpbin.org/delay/2",
        "https://httpbin.org/status/404",
    ]

    results = await scrape_urls(urls)
    for result in results:
        print(result)

asyncio.run(main())
```

### Async Database Operations

```python
import asyncio
from typing import List, Optional

# Simulated async database client
class AsyncDB:
    """Simulated async database."""

    async def execute(self, query: str) -> List[dict]:
        """Execute query."""
        await asyncio.sleep(0.1)
        return [{"id": 1, "name": "Example"}]

    async def fetch_one(self, query: str) -> Optional[dict]:
        """Fetch single row."""
        await asyncio.sleep(0.1)
        return {"id": 1, "name": "Example"}

async def get_user_data(db: AsyncDB, user_id: int) -> dict:
    """Fetch user and related data concurrently."""
    user_task = db.fetch_one(f"SELECT * FROM users WHERE id = {user_id}")
    orders_task = db.execute(f"SELECT * FROM orders WHERE user_id = {user_id}")
    profile_task = db.fetch_one(f"SELECT * FROM profiles WHERE user_id = {user_id}")

    user, orders, profile = await asyncio.gather(user_task, orders_task, profile_task)

    return {
        "user": user,
        "orders": orders,
        "profile": profile
    }

async def main():
    db = AsyncDB()
    user_data = await get_user_data(db, 1)
    print(user_data)

asyncio.run(main())
```

### WebSocket Server

```python
import asyncio
from typing import Set

# Simulated WebSocket connection
class WebSocket:
    """Simulated WebSocket."""

    def __init__(self, client_id: str):
        self.client_id = client_id

    async def send(self, message: str):
        """Send message."""
        print(f"Sending to {self.client_id}: {message}")
        await asyncio.sleep(0.01)

    async def recv(self) -> str:
        """Receive message."""
        await asyncio.sleep(1)
        return f"Message from {self.client_id}"

class WebSocketServer:
    """Simple WebSocket server."""

    def __init__(self):
        self.clients: Set[WebSocket] = set()

    async def register(self, websocket: WebSocket):
        """Register new client."""
        self.clients.add(websocket)
        print(f"Client {websocket.client_id} connected")

    async def unregister(self, websocket: WebSocket):
        """Unregister client."""
        self.clients.remove(websocket)
        print(f"Client {websocket.client_id} disconnected")

    async def broadcast(self, message: str):
        """Broadcast message to all clients."""
        if self.clients:
            tasks = [client.send(message) for client in self.clients]
            await asyncio.gather(*tasks)

    async def handle_client(self, websocket: WebSocket):
        """Handle individual client connection."""
        await self.register(websocket)
        try:
            async for message in self.message_iterator(websocket):
                await self.broadcast(f"{websocket.client_id}: {message}")
        finally:
            await self.unregister(websocket)

    async def message_iterator(self, websocket: WebSocket):
        """Iterate over messages from client."""
        for _ in range(3):  # Simulate 3 messages
            yield await websocket.recv()
```

## Performance Best Practices

### 1. Use Connection Pools

```python
import asyncio
import aiohttp

async def with_connection_pool():
    """Use connection pool for efficiency."""
    connector = aiohttp.TCPConnector(limit=100, limit_per_host=10)

    async with aiohttp.ClientSession(connector=connector) as session:
        tasks = [session.get(f"https://api.example.com/item/{i}") for i in range(50)]
        responses = await asyncio.gather(*tasks)
        return responses
```

### 2. Batch Operations

```python
async def batch_process(items: List[str], batch_size: int = 10):
    """Process items in batches."""
    for i in range(0, len(items), batch_size):
        batch = items[i:i + batch_size]
        tasks = [process_item(item) for item in batch]
        await asyncio.gather(*tasks)
        print(f"Processed batch {i // batch_size + 1}")

async def process_item(item: str):
    """Process single item."""
    await asyncio.sleep(0.1)
    return f"Processed: {item}"
```

### 3. Avoid Blocking Operations

```python
import asyncio
import concurrent.futures
from typing import Any

def blocking_operation(data: Any) -> Any:
    """CPU-intensive blocking operation."""
    import time
    time.sleep(1)
    return data * 2

async def run_in_executor(data: Any) -> Any:
    """Run blocking operation in thread pool."""
    loop = asyncio.get_event_loop()
    with concurrent.futures.ThreadPoolExecutor() as pool:
        result = await loop.run_in_executor(pool, blocking_operation, data)
        return result

async def main():
    results = await asyncio.gather(*[run_in_executor(i) for i in range(5)])
    print(results)

asyncio.run(main())
```

## Common Pitfalls

### 1. Forgetting await

```python
# Wrong - returns coroutine object, doesn't execute
result = async_function()

# Correct
result = await async_function()
```

### 2. Blocking the Event Loop

```python
# Wrong - blocks event loop
import time
async def bad():
    time.sleep(1)  # Blocks!

# Correct
async def good():
    await asyncio.sleep(1)  # Non-blocking
```

### 3. Not Handling Cancellation

```python
async def cancelable_task():
    """Task that handles cancellation."""
    try:
        while True:
            await asyncio.sleep(1)
            print("Working...")
    except asyncio.CancelledError:
        print("Task cancelled, cleaning up...")
        # Perform cleanup
        raise  # Re-raise to propagate cancellation
```

### 4. Mixing Sync and Async Code

```python
# Wrong - can't call async from sync directly
def sync_function():
    result = await async_function()  # SyntaxError!

# Correct
def sync_function():
    result = asyncio.run(async_function())
```

## Testing Async Code

```python
import asyncio
import pytest

# Using pytest-asyncio
@pytest.mark.asyncio
async def test_async_function():
    """Test async function."""
    result = await fetch_data("https://api.example.com")
    assert result is not None

@pytest.mark.asyncio
async def test_with_timeout():
    """Test with timeout."""
    with pytest.raises(asyncio.TimeoutError):
        await asyncio.wait_for(slow_operation(5), timeout=1.0)
```

## Resources

- **Python asyncio documentation**: <https://docs.python.org/3/library/asyncio.html>
- **aiohttp**: Async HTTP client/server
- **FastAPI**: Modern async web framework
- **asyncpg**: Async PostgreSQL driver
- **motor**: Async MongoDB driver

## Best Practices Summary

1. **Use asyncio.run()** for entry point (Python 3.7+)
2. **Always await coroutines** to execute them
3. **Use gather() for concurrent execution** of multiple tasks
4. **Implement proper error handling** with try/except
5. **Use timeouts** to prevent hanging operations
6. **Pool connections** for better performance
7. **Avoid blocking operations** in async code
8. **Use semaphores** for rate limiting
9. **Handle task cancellation** properly
10. **Test async code** with pytest-asyncio

## Python Packaging

# Python Packaging

Comprehensive guide to creating, structuring, and distributing Python packages using modern packaging tools, pyproject.toml, and publishing to PyPI.

## When to Use This Skill

- Creating Python libraries for distribution
- Building command-line tools with entry points
- Publishing packages to PyPI or private repositories
- Setting up Python project structure
- Creating installable packages with dependencies
- Building wheels and source distributions
- Versioning and releasing Python packages
- Creating namespace packages
- Implementing package metadata and classifiers

## Core Concepts

### 1. Package Structure

- **Source layout**: `src/package_name/` (recommended)
- **Flat layout**: `package_name/` (simpler but less flexible)
- **Package metadata**: pyproject.toml, setup.py, or setup.cfg
- **Distribution formats**: wheel (.whl) and source distribution (.tar.gz)

### 2. Modern Packaging Standards

- **PEP 517/518**: Build system requirements
- **PEP 621**: Metadata in pyproject.toml
- **PEP 660**: Editable installs
- **pyproject.toml**: Single source of configuration

### 3. Build Backends

- **setuptools**: Traditional, widely used
- **hatchling**: Modern, opinionated
- **flit**: Lightweight, for pure Python
- **poetry**: Dependency management + packaging

### 4. Distribution

- **PyPI**: Python Package Index (public)
- **TestPyPI**: Testing before production
- **Private repositories**: JFrog, AWS CodeArtifact, etc.

## Quick Start

### Minimal Package Structure

```
my-package/
├── pyproject.toml
├── README.md
├── LICENSE
├── src/
│   └── my_package/
│       ├── __init__.py
│       └── module.py
└── tests/
    └── test_module.py
```

### Minimal pyproject.toml

```toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[project]
name = "my-package"
version = "0.1.0"
description = "A short description"
authors = [{name = "Your Name", email = "you@example.com"}]
readme = "README.md"
requires-python = ">=3.8"
dependencies = [
    "requests>=2.28.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "black>=22.0",
]
```

## Package Structure Patterns

### Pattern 1: Source Layout (Recommended)

```
my-package/
├── pyproject.toml
├── README.md
├── LICENSE
├── .gitignore
├── src/
│   └── my_package/
│       ├── __init__.py
│       ├── core.py
│       ├── utils.py
│       └── py.typed          # For type hints
├── tests/
│   ├── __init__.py
│   ├── test_core.py
│   └── test_utils.py
└── docs/
    └── index.md
```

**Advantages:**

- Prevents accidentally importing from source
- Cleaner test imports
- Better isolation

**pyproject.toml for source layout:**

```toml
[tool.setuptools.packages.find]
where = ["src"]
```

### Pattern 2: Flat Layout

```
my-package/
├── pyproject.toml
├── README.md
├── my_package/
│   ├── __init__.py
│   └── module.py
└── tests/
    └── test_module.py
```

**Simpler but:**

- Can import package without installing
- Less professional for libraries

### Pattern 3: Multi-Package Project

```
project/
├── pyproject.toml
├── packages/
│   ├── package-a/
│   │   └── src/
│   │       └── package_a/
│   └── package-b/
│       └── src/
│           └── package_b/
└── tests/
```

## Complete pyproject.toml Examples

### Pattern 4: Full-Featured pyproject.toml

```toml
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "my-awesome-package"
version = "1.0.0"
description = "An awesome Python package"
readme = "README.md"
requires-python = ">=3.8"
license = {text = "MIT"}
authors = [
    {name = "Your Name", email = "you@example.com"},
]
maintainers = [
    {name = "Maintainer Name", email = "maintainer@example.com"},
]
keywords = ["example", "package", "awesome"]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
]

dependencies = [
    "requests>=2.28.0,<3.0.0",
    "click>=8.0.0",
    "pydantic>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "black>=23.0.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
]
docs = [
    "sphinx>=5.0.0",
    "sphinx-rtd-theme>=1.0.0",
]
all = [
    "my-awesome-package[dev,docs]",
]

[project.urls]
Homepage = "https://github.com/username/my-awesome-package"
Documentation = "https://my-awesome-package.readthedocs.io"
Repository = "https://github.com/username/my-awesome-package"
"Bug Tracker" = "https://github.com/username/my-awesome-package/issues"
Changelog = "https://github.com/username/my-awesome-package/blob/main/CHANGELOG.md"

[project.scripts]
my-cli = "my_package.cli:main"
awesome-tool = "my_package.tools:run"

[project.entry-points."my_package.plugins"]
plugin1 = "my_package.plugins:plugin1"

[tool.setuptools]
package-dir = {"" = "src"}
zip-safe = false

[tool.setuptools.packages.find]
where = ["src"]
include = ["my_package*"]
exclude = ["tests*"]

[tool.setuptools.package-data]
my_package = ["py.typed", "*.pyi", "data/*.json"]

# Black configuration
[tool.black]
line-length = 100
target-version = ["py38", "py39", "py310", "py311"]
include = '\.pyi?$'

# Ruff configuration
[tool.ruff]
line-length = 100
target-version = "py38"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]

# MyPy configuration
[tool.mypy]
python_version = "3.8"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

# Pytest configuration
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = "-v --cov=my_package --cov-report=term-missing"

# Coverage configuration
[tool.coverage.run]
source = ["src"]
omit = ["*/tests/*"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
]
```

### Pattern 5: Dynamic Versioning

```toml
[build-system]
requires = ["setuptools>=61.0", "setuptools-scm>=8.0"]
build-backend = "setuptools.build_meta"

[project]
name = "my-package"
dynamic = ["version"]
description = "Package with dynamic version"

[tool.setuptools.dynamic]
version = {attr = "my_package.__version__"}

# Or use setuptools-scm for git-based versioning
[tool.setuptools_scm]
write_to = "src/my_package/_version.py"
```

**In **init**.py:**

```python
# src/my_package/__init__.py
__version__ = "1.0.0"

# Or with setuptools-scm
from importlib.metadata import version
__version__ = version("my-package")
```

## Command-Line Interface (CLI) Patterns

### Pattern 6: CLI with Click

```python
# src/my_package/cli.py
import click

@click.group()
@click.version_option()
def cli():
    """My awesome CLI tool."""
    pass

@cli.command()
@click.argument("name")
@click.option("--greeting", default="Hello", help="Greeting to use")
def greet(name: str, greeting: str):
    """Greet someone."""
    click.echo(f"{greeting}, {name}!")

@cli.command()
@click.option("--count", default=1, help="Number of times to repeat")
def repeat(count: int):
    """Repeat a message."""
    for i in range(count):
        click.echo(f"Message {i + 1}")

def main():
    """Entry point for CLI."""
    cli()

if __name__ == "__main__":
    main()
```

**Register in pyproject.toml:**

```toml
[project.scripts]
my-tool = "my_package.cli:main"
```

**Usage:**

```bash
pip install -e .
my-tool greet World
my-tool greet Alice --greeting="Hi"
my-tool repeat --count=3
```

### Pattern 7: CLI with argparse

```python
# src/my_package/cli.py
import argparse
import sys

def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="My awesome tool",
        prog="my-tool"
    )

    parser.add_argument(
        "--version",
        action="version",
        version="%(prog)s 1.0.0"
    )

    subparsers = parser.add_subparsers(dest="command", help="Commands")

    # Add subcommand
    process_parser = subparsers.add_parser("process", help="Process data")
    process_parser.add_argument("input_file", help="Input file path")
    process_parser.add_argument(
        "--output", "-o",
        default="output.txt",
        help="Output file path"
    )

    args = parser.parse_args()

    if args.command == "process":
        process_data(args.input_file, args.output)
    else:
        parser.print_help()
        sys.exit(1)

def process_data(input_file: str, output_file: str):
    """Process data from input to output."""
    print(f"Processing {input_file} -> {output_file}")

if __name__ == "__main__":
    main()
```

## Building and Publishing

### Pattern 8: Build Package Locally

```bash
# Install build tools
pip install build twine

# Build distribution
python -m build

# This creates:
# dist/
#   my-package-1.0.0.tar.gz (source distribution)
#   my_package-1.0.0-py3-none-any.whl (wheel)

# Check the distribution
twine check dist/*
```

### Pattern 9: Publishing to PyPI

```bash
# Install publishing tools
pip install twine

# Test on TestPyPI first
twine upload --repository testpypi dist/*

# Install from TestPyPI to test
pip install --index-url https://test.pypi.org/simple/ my-package

# If all good, publish to PyPI
twine upload dist/*
```

**Using API tokens (recommended):**

```bash
# Create ~/.pypirc
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
username = __token__
password = pypi-...your-token...

[testpypi]
username = __token__
password = pypi-...your-test-token...
```

### Pattern 10: Automated Publishing with GitHub Actions

```yaml
# .github/workflows/publish.yml
name: Publish to PyPI

on:
  release:
    types: [created]

jobs:
  publish:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: "3.11"

      - name: Install dependencies
        run: |
          pip install build twine

      - name: Build package
        run: python -m build

      - name: Check package
        run: twine check dist/*

      - name: Publish to PyPI
        env:
          TWINE_USERNAME: __token__
          TWINE_PASSWORD: ${{ secrets.PYPI_API_TOKEN }}
        run: twine upload dist/*
```

## Advanced Patterns

### Pattern 11: Including Data Files

```toml
[tool.setuptools.package-data]
my_package = [
    "data/*.json",
    "templates/*.html",
    "static/css/*.css",
    "py.typed",
]
```

**Accessing data files:**

```python
# src/my_package/loader.py
from importlib.resources import files
import json

def load_config():
    """Load configuration from package data."""
    config_file = files("my_package").joinpath("data/config.json")
    with config_file.open() as f:
        return json.load(f)

# Python 3.9+
from importlib.resources import files

data = files("my_package").joinpath("data/file.txt").read_text()
```

### Pattern 12: Namespace Packages

**For large projects split across multiple repositories:**

```
# Package 1: company-core
company/
└── core/
    ├── __init__.py
    └── models.py

# Package 2: company-api
company/
└── api/
    ├── __init__.py
    └── routes.py
```

**Do NOT include **init**.py in the namespace directory (company/):**

```toml
# company-core/pyproject.toml
[project]
name = "company-core"

[tool.setuptools.packages.find]
where = ["."]
include = ["company.core*"]

# company-api/pyproject.toml
[project]
name = "company-api"

[tool.setuptools.packages.find]
where = ["."]
include = ["company.api*"]
```

**Usage:**

```python
# Both packages can be imported under same namespace
from company.core import models
from company.api import routes
```

### Pattern 13: C Extensions

```toml
[build-system]
requires = ["setuptools>=61.0", "wheel", "Cython>=0.29"]
build-backend = "setuptools.build_meta"

[tool.setuptools]
ext-modules = [
    {name = "my_package.fast_module", sources = ["src/fast_module.c"]},
]
```

**Or with setup.py:**

```python
# setup.py
from setuptools import setup, Extension

setup(
    ext_modules=[
        Extension(
            "my_package.fast_module",
            sources=["src/fast_module.c"],
            include_dirs=["src/include"],
        )
    ]
)
```

## Version Management

### Pattern 14: Semantic Versioning

```python
# src/my_package/__init__.py
__version__ = "1.2.3"

# Semantic versioning: MAJOR.MINOR.PATCH
# MAJOR: Breaking changes
# MINOR: New features (backward compatible)
# PATCH: Bug fixes
```

**Version constraints in dependencies:**

```toml
dependencies = [
    "requests>=2.28.0,<3.0.0",  # Compatible range
    "click~=8.1.0",              # Compatible release (~= 8.1.0 means >=8.1.0,<8.2.0)
    "pydantic>=2.0",             # Minimum version
    "numpy==1.24.3",             # Exact version (avoid if possible)
]
```

### Pattern 15: Git-Based Versioning

```toml
[build-system]
requires = ["setuptools>=61.0", "setuptools-scm>=8.0"]
build-backend = "setuptools.build_meta"

[project]
name = "my-package"
dynamic = ["version"]

[tool.setuptools_scm]
write_to = "src/my_package/_version.py"
version_scheme = "post-release"
local_scheme = "dirty-tag"
```

**Creates versions like:**

- `1.0.0` (from git tag)
- `1.0.1.dev3+g1234567` (3 commits after tag)

## Testing Installation

### Pattern 16: Editable Install

```bash
# Install in development mode
pip install -e .

# With optional dependencies
pip install -e ".[dev]"
pip install -e ".[dev,docs]"

# Now changes to source code are immediately reflected
```

### Pattern 17: Testing in Isolated Environment

```bash
# Create virtual environment
python -m venv test-env
source test-env/bin/activate  # Linux/Mac
# test-env\Scripts\activate  # Windows

# Install package
pip install dist/my_package-1.0.0-py3-none-any.whl

# Test it works
python -c "import my_package; print(my_package.__version__)"

# Test CLI
my-tool --help

# Cleanup
deactivate
rm -rf test-env
```

## Documentation

### Pattern 18: README.md Template

````markdown
# My Package

[![PyPI version](https://badge.fury.io/py/my-package.svg)](https://pypi.org/project/my-package/)
[![Python versions](https://img.shields.io/pypi/pyversions/my-package.svg)](https://pypi.org/project/my-package/)
[![Tests](https://github.com/username/my-package/workflows/Tests/badge.svg)](https://github.com/username/my-package/actions)

Brief description of your package.

## Installation

```bash
pip install my-package
```
````

## Quick Start

```python
from my_package import something

result = something.do_stuff()
```

## Features

- Feature 1
- Feature 2
- Feature 3

## Documentation

Full documentation: <https://my-package.readthedocs.io>

## Development

```bash
git clone https://github.com/username/my-package.git
cd my-package
pip install -e ".[dev]"
pytest
```

## License

MIT

````

## Common Patterns

### Pattern 19: Multi-Architecture Wheels

```yaml
# .github/workflows/wheels.yml
name: Build wheels

on: [push, pull_request]

jobs:
  build_wheels:
    name: Build wheels on ${{ matrix.os }}
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]

    steps:
      - uses: actions/checkout@v3

      - name: Build wheels
        uses: pypa/cibuildwheel@v2.16.2

      - uses: actions/upload-artifact@v3
        with:
          path: ./wheelhouse/*.whl
````

### Pattern 20: Private Package Index

```bash
# Install from private index
pip install my-package --index-url https://private.pypi.org/simple/

# Or add to pip.conf
[global]
index-url = https://private.pypi.org/simple/
extra-index-url = https://pypi.org/simple/

# Upload to private index
twine upload --repository-url https://private.pypi.org/ dist/*
```

## File Templates

### .gitignore for Python Packages

```gitignore
# Build artifacts
build/
dist/
*.egg-info/
*.egg
.eggs/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so

# Virtual environments
venv/
env/
ENV/

# IDE
.vscode/
.idea/
*.swp

# Testing
.pytest_cache/
.coverage
htmlcov/

# Distribution
*.whl
*.tar.gz
```

### MANIFEST.in

```
# MANIFEST.in
include README.md
include LICENSE
include pyproject.toml

recursive-include src/my_package/data *.json
recursive-include src/my_package/templates *.html
recursive-exclude * __pycache__
recursive-exclude * *.py[co]
```

## Checklist for Publishing

- [ ] Code is tested (pytest passing)
- [ ] Documentation is complete (README, docstrings)
- [ ] Version number updated
- [ ] CHANGELOG.md updated
- [ ] License file included
- [ ] pyproject.toml is complete
- [ ] Package builds without errors
- [ ] Installation tested in clean environment
- [ ] CLI tools work (if applicable)
- [ ] PyPI metadata is correct (classifiers, keywords)
- [ ] GitHub repository linked
- [ ] Tested on TestPyPI first
- [ ] Git tag created for release

## Resources

- **Python Packaging Guide**: <https://packaging.python.org/>
- **PyPI**: <https://pypi.org/>
- **TestPyPI**: <https://test.pypi.org/>
- **setuptools documentation**: <https://setuptools.pypa.io/>
- **build**: <https://pypa-build.readthedocs.io/>
- **twine**: <https://twine.readthedocs.io/>

## Best Practices Summary

1. **Use src/ layout** for cleaner package structure
2. **Use pyproject.toml** for modern packaging
3. **Pin build dependencies** in build-system.requires
4. **Version appropriately** with semantic versioning
5. **Include all metadata** (classifiers, URLs, etc.)
6. **Test installation** in clean environments
7. **Use TestPyPI** before publishing to PyPI
8. **Document thoroughly** with README and docstrings
9. **Include LICENSE** file
10. **Automate publishing** with CI/CD

## Python Performance Optimization

# Python Performance Optimization

Comprehensive guide to profiling, analyzing, and optimizing Python code for better performance, including CPU profiling, memory optimization, and implementation best practices.

## When to Use This Skill

- Identifying performance bottlenecks in Python applications
- Reducing application latency and response times
- Optimizing CPU-intensive operations
- Reducing memory consumption and memory leaks
- Improving database query performance
- Optimizing I/O operations
- Speeding up data processing pipelines
- Implementing high-performance algorithms
- Profiling production applications

## Core Concepts

### 1. Profiling Types

- **CPU Profiling**: Identify time-consuming functions
- **Memory Profiling**: Track memory allocation and leaks
- **Line Profiling**: Profile at line-by-line granularity
- **Call Graph**: Visualize function call relationships

### 2. Performance Metrics

- **Execution Time**: How long operations take
- **Memory Usage**: Peak and average memory consumption
- **CPU Utilization**: Processor usage patterns
- **I/O Wait**: Time spent on I/O operations

### 3. Optimization Strategies

- **Algorithmic**: Better algorithms and data structures
- **Implementation**: More efficient code patterns
- **Parallelization**: Multi-threading/processing
- **Caching**: Avoid redundant computation
- **Native Extensions**: C/Rust for critical paths

## Quick Start

### Basic Timing

```python
import time

def measure_time():
    """Simple timing measurement."""
    start = time.time()

    # Your code here
    result = sum(range(1000000))

    elapsed = time.time() - start
    print(f"Execution time: {elapsed:.4f} seconds")
    return result

# Better: use timeit for accurate measurements
import timeit

execution_time = timeit.timeit(
    "sum(range(1000000))",
    number=100
)
print(f"Average time: {execution_time/100:.6f} seconds")
```

## Profiling Tools

### Pattern 1: cProfile - CPU Profiling

```python
import cProfile
import pstats
from pstats import SortKey

def slow_function():
    """Function to profile."""
    total = 0
    for i in range(1000000):
        total += i
    return total

def another_function():
    """Another function."""
    return [i**2 for i in range(100000)]

def main():
    """Main function to profile."""
    result1 = slow_function()
    result2 = another_function()
    return result1, result2

# Profile the code
if __name__ == "__main__":
    profiler = cProfile.Profile()
    profiler.enable()

    main()

    profiler.disable()

    # Print stats
    stats = pstats.Stats(profiler)
    stats.sort_stats(SortKey.CUMULATIVE)
    stats.print_stats(10)  # Top 10 functions

    # Save to file for later analysis
    stats.dump_stats("profile_output.prof")
```

**Command-line profiling:**

```bash
# Profile a script
python -m cProfile -o output.prof script.py

# View results
python -m pstats output.prof
# In pstats:
# sort cumtime
# stats 10
```

### Pattern 2: line_profiler - Line-by-Line Profiling

```python
# Install: pip install line-profiler

# Add @profile decorator (line_profiler provides this)
@profile
def process_data(data):
    """Process data with line profiling."""
    result = []
    for item in data:
        processed = item * 2
        result.append(processed)
    return result

# Run with:
# kernprof -l -v script.py
```

**Manual line profiling:**

```python
from line_profiler import LineProfiler

def process_data(data):
    """Function to profile."""
    result = []
    for item in data:
        processed = item * 2
        result.append(processed)
    return result

if __name__ == "__main__":
    lp = LineProfiler()
    lp.add_function(process_data)

    data = list(range(100000))

    lp_wrapper = lp(process_data)
    lp_wrapper(data)

    lp.print_stats()
```

### Pattern 3: memory_profiler - Memory Usage

```python
# Install: pip install memory-profiler

from memory_profiler import profile

@profile
def memory_intensive():
    """Function that uses lots of memory."""
    # Create large list
    big_list = [i for i in range(1000000)]

    # Create large dict
    big_dict = {i: i**2 for i in range(100000)}

    # Process data
    result = sum(big_list)

    return result

if __name__ == "__main__":
    memory_intensive()

# Run with:
# python -m memory_profiler script.py
```

### Pattern 4: py-spy - Production Profiling

```bash
# Install: pip install py-spy

# Profile a running Python process
py-spy top --pid 12345

# Generate flamegraph
py-spy record -o profile.svg --pid 12345

# Profile a script
py-spy record -o profile.svg -- python script.py

# Dump current call stack
py-spy dump --pid 12345
```

## Optimization Patterns

### Pattern 5: List Comprehensions vs Loops

```python
import timeit

# Slow: Traditional loop
def slow_squares(n):
    """Create list of squares using loop."""
    result = []
    for i in range(n):
        result.append(i**2)
    return result

# Fast: List comprehension
def fast_squares(n):
    """Create list of squares using comprehension."""
    return [i**2 for i in range(n)]

# Benchmark
n = 100000

slow_time = timeit.timeit(lambda: slow_squares(n), number=100)
fast_time = timeit.timeit(lambda: fast_squares(n), number=100)

print(f"Loop: {slow_time:.4f}s")
print(f"Comprehension: {fast_time:.4f}s")
print(f"Speedup: {slow_time/fast_time:.2f}x")

# Even faster for simple operations: map
def faster_squares(n):
    """Use map for even better performance."""
    return list(map(lambda x: x**2, range(n)))
```

### Pattern 6: Generator Expressions for Memory

```python
import sys

def list_approach():
    """Memory-intensive list."""
    data = [i**2 for i in range(1000000)]
    return sum(data)

def generator_approach():
    """Memory-efficient generator."""
    data = (i**2 for i in range(1000000))
    return sum(data)

# Memory comparison
list_data = [i for i in range(1000000)]
gen_data = (i for i in range(1000000))

print(f"List size: {sys.getsizeof(list_data)} bytes")
print(f"Generator size: {sys.getsizeof(gen_data)} bytes")

# Generators use constant memory regardless of size
```

### Pattern 7: String Concatenation

```python
import timeit

def slow_concat(items):
    """Slow string concatenation."""
    result = ""
    for item in items:
        result += str(item)
    return result

def fast_concat(items):
    """Fast string concatenation with join."""
    return "".join(str(item) for item in items)

def faster_concat(items):
    """Even faster with list."""
    parts = [str(item) for item in items]
    return "".join(parts)

items = list(range(10000))

# Benchmark
slow = timeit.timeit(lambda: slow_concat(items), number=100)
fast = timeit.timeit(lambda: fast_concat(items), number=100)
faster = timeit.timeit(lambda: faster_concat(items), number=100)

print(f"Concatenation (+): {slow:.4f}s")
print(f"Join (generator): {fast:.4f}s")
print(f"Join (list): {faster:.4f}s")
```

### Pattern 8: Dictionary Lookups vs List Searches

```python
import timeit

# Create test data
size = 10000
items = list(range(size))
lookup_dict = {i: i for i in range(size)}

def list_search(items, target):
    """O(n) search in list."""
    return target in items

def dict_search(lookup_dict, target):
    """O(1) search in dict."""
    return target in lookup_dict

target = size - 1  # Worst case for list

# Benchmark
list_time = timeit.timeit(
    lambda: list_search(items, target),
    number=1000
)
dict_time = timeit.timeit(
    lambda: dict_search(lookup_dict, target),
    number=1000
)

print(f"List search: {list_time:.6f}s")
print(f"Dict search: {dict_time:.6f}s")
print(f"Speedup: {list_time/dict_time:.0f}x")
```

### Pattern 9: Local Variable Access

```python
import timeit

# Global variable (slow)
GLOBAL_VALUE = 100

def use_global():
    """Access global variable."""
    total = 0
    for i in range(10000):
        total += GLOBAL_VALUE
    return total

def use_local():
    """Use local variable."""
    local_value = 100
    total = 0
    for i in range(10000):
        total += local_value
    return total

# Local is faster
global_time = timeit.timeit(use_global, number=1000)
local_time = timeit.timeit(use_local, number=1000)

print(f"Global access: {global_time:.4f}s")
print(f"Local access: {local_time:.4f}s")
print(f"Speedup: {global_time/local_time:.2f}x")
```

### Pattern 10: Function Call Overhead

```python
import timeit

def calculate_inline():
    """Inline calculation."""
    total = 0
    for i in range(10000):
        total += i * 2 + 1
    return total

def helper_function(x):
    """Helper function."""
    return x * 2 + 1

def calculate_with_function():
    """Calculation with function calls."""
    total = 0
    for i in range(10000):
        total += helper_function(i)
    return total

# Inline is faster due to no call overhead
inline_time = timeit.timeit(calculate_inline, number=1000)
function_time = timeit.timeit(calculate_with_function, number=1000)

print(f"Inline: {inline_time:.4f}s")
print(f"Function calls: {function_time:.4f}s")
```

## Advanced Optimization

### Pattern 11: NumPy for Numerical Operations

```python
import timeit
import numpy as np

def python_sum(n):
    """Sum using pure Python."""
    return sum(range(n))

def numpy_sum(n):
    """Sum using NumPy."""
    return np.arrange(n).sum()

n = 1000000

python_time = timeit.timeit(lambda: python_sum(n), number=100)
numpy_time = timeit.timeit(lambda: numpy_sum(n), number=100)

print(f"Python: {python_time:.4f}s")
print(f"NumPy: {numpy_time:.4f}s")
print(f"Speedup: {python_time/numpy_time:.2f}x")

# Vectorized operations
def python_multiply():
    """Element-wise multiplication in Python."""
    a = list(range(100000))
    b = list(range(100000))
    return [x * y for x, y in zip(a, b)]

def numpy_multiply():
    """Vectorized multiplication in NumPy."""
    a = np.arrange(100000)
    b = np.arrange(100000)
    return a * b

py_time = timeit.timeit(python_multiply, number=100)
np_time = timeit.timeit(numpy_multiply, number=100)

print(f"\nPython multiply: {py_time:.4f}s")
print(f"NumPy multiply: {np_time:.4f}s")
print(f"Speedup: {py_time/np_time:.2f}x")
```

### Pattern 12: Caching with functools.lru_cache

```python
from functools import lru_cache
import timeit

def fibonacci_slow(n):
    """Recursive fibonacci without caching."""
    if n < 2:
        return n
    return fibonacci_slow(n-1) + fibonacci_slow(n-2)

@lru_cache(maxsize=None)
def fibonacci_fast(n):
    """Recursive fibonacci with caching."""
    if n < 2:
        return n
    return fibonacci_fast(n-1) + fibonacci_fast(n-2)

# Massive speedup for recursive algorithms
n = 30

slow_time = timeit.timeit(lambda: fibonacci_slow(n), number=1)
fast_time = timeit.timeit(lambda: fibonacci_fast(n), number=1000)

print(f"Without cache (1 run): {slow_time:.4f}s")
print(f"With cache (1000 runs): {fast_time:.4f}s")

# Cache info
print(f"Cache info: {fibonacci_fast.cache_info()}")
```

### Pattern 13: Using **slots** for Memory

```python
import sys

class RegularClass:
    """Regular class with __dict__."""
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

class SlottedClass:
    """Class with __slots__ for memory efficiency."""
    __slots__ = ['x', 'y', 'z']

    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

# Memory comparison
regular = RegularClass(1, 2, 3)
slotted = SlottedClass(1, 2, 3)

print(f"Regular class size: {sys.getsizeof(regular)} bytes")
print(f"Slotted class size: {sys.getsizeof(slotted)} bytes")

# Significant savings with many instances
regular_objects = [RegularClass(i, i+1, i+2) for i in range(10000)]
slotted_objects = [SlottedClass(i, i+1, i+2) for i in range(10000)]

print(f"\nMemory for 10000 regular objects: ~{sys.getsizeof(regular) * 10000} bytes")
print(f"Memory for 10000 slotted objects: ~{sys.getsizeof(slotted) * 10000} bytes")
```

### Pattern 14: Multiprocessing for CPU-Bound Tasks

```python
import multiprocessing as mp
import time

def cpu_intensive_task(n):
    """CPU-intensive calculation."""
    return sum(i**2 for i in range(n))

def sequential_processing():
    """Process tasks sequentially."""
    start = time.time()
    results = [cpu_intensive_task(1000000) for _ in range(4)]
    elapsed = time.time() - start
    return elapsed, results

def parallel_processing():
    """Process tasks in parallel."""
    start = time.time()
    with mp.Pool(processes=4) as pool:
        results = pool.map(cpu_intensive_task, [1000000] * 4)
    elapsed = time.time() - start
    return elapsed, results

if __name__ == "__main__":
    seq_time, seq_results = sequential_processing()
    par_time, par_results = parallel_processing()

    print(f"Sequential: {seq_time:.2f}s")
    print(f"Parallel: {par_time:.2f}s")
    print(f"Speedup: {seq_time/par_time:.2f}x")
```

### Pattern 15: Async I/O for I/O-Bound Tasks

```python
import asyncio
import aiohttp
import time
import requests

urls = [
    "https://httpbin.org/delay/1",
    "https://httpbin.org/delay/1",
    "https://httpbin.org/delay/1",
    "https://httpbin.org/delay/1",
]

def synchronous_requests():
    """Synchronous HTTP requests."""
    start = time.time()
    results = []
    for url in urls:
        response = requests.get(url)
        results.append(response.status_code)
    elapsed = time.time() - start
    return elapsed, results

async def async_fetch(session, url):
    """Async HTTP request."""
    async with session.get(url) as response:
        return response.status

async def asynchronous_requests():
    """Asynchronous HTTP requests."""
    start = time.time()
    async with aiohttp.ClientSession() as session:
        tasks = [async_fetch(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
    elapsed = time.time() - start
    return elapsed, results

# Async is much faster for I/O-bound work
sync_time, sync_results = synchronous_requests()
async_time, async_results = asyncio.run(asynchronous_requests())

print(f"Synchronous: {sync_time:.2f}s")
print(f"Asynchronous: {async_time:.2f}s")
print(f"Speedup: {sync_time/async_time:.2f}x")
```

## Database Optimization

### Pattern 16: Batch Database Operations

```python
import sqlite3
import time

def create_db():
    """Create test database."""
    conn = sqlite3.connect(":memory:")
    conn.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)")
    return conn

def slow_inserts(conn, count):
    """Insert records one at a time."""
    start = time.time()
    cursor = conn.cursor()
    for i in range(count):
        cursor.execute("INSERT INTO users (name) VALUES (?)", (f"User {i}",))
        conn.commit()  # Commit each insert
    elapsed = time.time() - start
    return elapsed

def fast_inserts(conn, count):
    """Batch insert with single commit."""
    start = time.time()
    cursor = conn.cursor()
    data = [(f"User {i}",) for i in range(count)]
    cursor.executemany("INSERT INTO users (name) VALUES (?)", data)
    conn.commit()  # Single commit
    elapsed = time.time() - start
    return elapsed

# Benchmark
conn1 = create_db()
slow_time = slow_inserts(conn1, 1000)

conn2 = create_db()
fast_time = fast_inserts(conn2, 1000)

print(f"Individual inserts: {slow_time:.4f}s")
print(f"Batch insert: {fast_time:.4f}s")
print(f"Speedup: {slow_time/fast_time:.2f}x")
```

### Pattern 17: Query Optimization

```python
# Use indexes for frequently queried columns
"""
-- Slow: No index
SELECT * FROM users WHERE email = 'user@example.com';

-- Fast: With index
CREATE INDEX idx_users_email ON users(email);
SELECT * FROM users WHERE email = 'user@example.com';
"""

# Use query planning
import sqlite3

conn = sqlite3.connect("example.db")
cursor = conn.cursor()

# Analyze query performance
cursor.execute("EXPLAIN QUERY PLAN SELECT * FROM users WHERE email = ?", ("test@example.com",))
print(cursor.fetchall())

# Use SELECT only needed columns
# Slow: SELECT *
# Fast: SELECT id, name
```

## Memory Optimization

### Pattern 18: Detecting Memory Leaks

```python
import tracemalloc
import gc

def memory_leak_example():
    """Example that leaks memory."""
    leaked_objects = []

    for i in range(100000):
        # Objects added but never removed
        leaked_objects.append([i] * 100)

    # In real code, this would be an unintended reference

def track_memory_usage():
    """Track memory allocations."""
    tracemalloc.start()

    # Take snapshot before
    snapshot1 = tracemalloc.take_snapshot()

    # Run code
    memory_leak_example()

    # Take snapshot after
    snapshot2 = tracemalloc.take_snapshot()

    # Compare
    top_stats = snapshot2.compare_to(snapshot1, 'lineno')

    print("Top 10 memory allocations:")
    for stat in top_stats[:10]:
        print(stat)

    tracemalloc.stop()

# Monitor memory
track_memory_usage()

# Force garbage collection
gc.collect()
```

### Pattern 19: Iterators vs Lists

```python
import sys

def process_file_list(filename):
    """Load entire file into memory."""
    with open(filename) as f:
        lines = f.readlines()  # Loads all lines
        return sum(1 for line in lines if line.strip())

def process_file_iterator(filename):
    """Process file line by line."""
    with open(filename) as f:
        return sum(1 for line in f if line.strip())

# Iterator uses constant memory
# List loads entire file into memory
```

### Pattern 20: Weakref for Caches

```python
import weakref

class CachedResource:
    """Resource that can be garbage collected."""
    def __init__(self, data):
        self.data = data

# Regular cache prevents garbage collection
regular_cache = {}

def get_resource_regular(key):
    """Get resource from regular cache."""
    if key not in regular_cache:
        regular_cache[key] = CachedResource(f"Data for {key}")
    return regular_cache[key]

# Weak reference cache allows garbage collection
weak_cache = weakref.WeakValueDictionary()

def get_resource_weak(key):
    """Get resource from weak cache."""
    resource = weak_cache.get(key)
    if resource is None:
        resource = CachedResource(f"Data for {key}")
        weak_cache[key] = resource
    return resource

# When no strong references exist, objects can be GC'd
```

## Benchmarking Tools

### Custom Benchmark Decorator

```python
import time
from functools import wraps

def benchmark(func):
    """Decorator to benchmark function execution."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        print(f"{func.__name__} took {elapsed:.6f} seconds")
        return result
    return wrapper

@benchmark
def slow_function():
    """Function to benchmark."""
    time.sleep(0.5)
    return sum(range(1000000))

result = slow_function()
```

### Performance Testing with pytest-benchmark

```python
# Install: pip install pytest-benchmark

def test_list_comprehension(benchmark):
    """Benchmark list comprehension."""
    result = benchmark(lambda: [i**2 for i in range(10000)])
    assert len(result) == 10000

def test_map_function(benchmark):
    """Benchmark map function."""
    result = benchmark(lambda: list(map(lambda x: x**2, range(10000))))
    assert len(result) == 10000

# Run with: pytest test_performance.py --benchmark-compare
```

## Best Practices

1. **Profile before optimizing** - Measure to find real bottlenecks
2. **Focus on hot paths** - Optimize code that runs most frequently
3. **Use appropriate data structures** - Dict for lookups, set for membership
4. **Avoid premature optimization** - Clarity first, then optimize
5. **Use built-in functions** - They're implemented in C
6. **Cache expensive computations** - Use lru_cache
7. **Batch I/O operations** - Reduce system calls
8. **Use generators** for large datasets
9. **Consider NumPy** for numerical operations
10. **Profile production code** - Use py-spy for live systems

## Common Pitfalls

- Optimizing without profiling
- Using global variables unnecessarily
- Not using appropriate data structures
- Creating unnecessary copies of data
- Not using connection pooling for databases
- Ignoring algorithmic complexity
- Over-optimizing rare code paths
- Not considering memory usage

## Resources

- **cProfile**: Built-in CPU profiler
- **memory_profiler**: Memory usage profiling
- **line_profiler**: Line-by-line profiling
- **py-spy**: Sampling profiler for production
- **NumPy**: High-performance numerical computing
- **Cython**: Compile Python to C
- **PyPy**: Alternative Python interpreter with JIT

## Performance Checklist

- [ ] Profiled code to identify bottlenecks
- [ ] Used appropriate data structures
- [ ] Implemented caching where beneficial
- [ ] Optimized database queries
- [ ] Used generators for large datasets
- [ ] Considered multiprocessing for CPU-bound tasks
- [ ] Used async I/O for I/O-bound tasks
- [ ] Minimized function call overhead in hot loops
- [ ] Checked for memory leaks
- [ ] Benchmarked before and after optimization

## Python Testing Patterns

# Python Testing Patterns

Comprehensive guide to implementing robust testing strategies in Python using pytest, fixtures, mocking, parameterization, and test-driven development practices.

## When to Use This Skill

- Writing unit tests for Python code
- Setting up test suites and test infrastructure
- Implementing test-driven development (TDD)
- Creating integration tests for APIs and services
- Mocking external dependencies and services
- Testing async code and concurrent operations
- Setting up continuous testing in CI/CD
- Implementing property-based testing
- Testing database operations
- Debugging failing tests

## Core Concepts

### 1. Test Types

- **Unit Tests**: Test individual functions/classes in isolation
- **Integration Tests**: Test interaction between components
- **Functional Tests**: Test complete features end-to-end
- **Performance Tests**: Measure speed and resource usage

### 2. Test Structure (AAA Pattern)

- **Arrange**: Set up test data and preconditions
- **Act**: Execute the code under test
- **Assert**: Verify the results

### 3. Test Coverage

- Measure what code is exercised by tests
- Identify untested code paths
- Aim for meaningful coverage, not just high percentages

### 4. Test Isolation

- Tests should be independent
- No shared state between tests
- Each test should clean up after itself

## Quick Start

```python
# test_example.py
def add(a, b):
    return a + b

def test_add():
    """Basic test example."""
    result = add(2, 3)
    assert result == 5

def test_add_negative():
    """Test with negative numbers."""
    assert add(-1, 1) == 0

# Run with: pytest test_example.py
```

## Fundamental Patterns

### Pattern 1: Basic pytest Tests

```python
# test_calculator.py
import pytest

class Calculator:
    """Simple calculator for testing."""

    def add(self, a: float, b: float) -> float:
        return a + b

    def subtract(self, a: float, b: float) -> float:
        return a - b

    def multiply(self, a: float, b: float) -> float:
        return a * b

    def divide(self, a: float, b: float) -> float:
        if b == 0:
            raise ValueError("Cannot divide by zero")
        return a / b


def test_addition():
    """Test addition."""
    calc = Calculator()
    assert calc.add(2, 3) == 5
    assert calc.add(-1, 1) == 0
    assert calc.add(0, 0) == 0


def test_subtraction():
    """Test subtraction."""
    calc = Calculator()
    assert calc.subtract(5, 3) == 2
    assert calc.subtract(0, 5) == -5


def test_multiplication():
    """Test multiplication."""
    calc = Calculator()
    assert calc.multiply(3, 4) == 12
    assert calc.multiply(0, 5) == 0


def test_division():
    """Test division."""
    calc = Calculator()
    assert calc.divide(6, 3) == 2
    assert calc.divide(5, 2) == 2.5


def test_division_by_zero():
    """Test division by zero raises error."""
    calc = Calculator()
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        calc.divide(5, 0)
```

### Pattern 2: Fixtures for Setup and Teardown

```python
# test_database.py
import pytest
from typing import Generator

class Database:
    """Simple database class."""

    def __init__(self, connection_string: str):
        self.connection_string = connection_string
        self.connected = False

    def connect(self):
        """Connect to database."""
        self.connected = True

    def disconnect(self):
        """Disconnect from database."""
        self.connected = False

    def query(self, sql: str) -> list:
        """Execute query."""
        if not self.connected:
            raise RuntimeError("Not connected")
        return [{"id": 1, "name": "Test"}]


@pytest.fixture
def db() -> Generator[Database, None, None]:
    """Fixture that provides connected database."""
    # Setup
    database = Database("sqlite:///:memory:")
    database.connect()

    # Provide to test
    yield database

    # Teardown
    database.disconnect()


def test_database_query(db):
    """Test database query with fixture."""
    results = db.query("SELECT * FROM users")
    assert len(results) == 1
    assert results[0]["name"] == "Test"


@pytest.fixture(scope="session")
def app_config():
    """Session-scoped fixture - created once per test session."""
    return {
        "database_url": "postgresql://localhost/test",
        "api_key": "test-key",
        "debug": True
    }


@pytest.fixture(scope="module")
def api_client(app_config):
    """Module-scoped fixture - created once per test module."""
    # Setup expensive resource
    client = {"config": app_config, "session": "active"}
    yield client
    # Cleanup
    client["session"] = "closed"


def test_api_client(api_client):
    """Test using api client fixture."""
    assert api_client["session"] == "active"
    assert api_client["config"]["debug"] is True
```

### Pattern 3: Parameterized Tests

```python
# test_validation.py
import pytest

def is_valid_email(email: str) -> bool:
    """Check if email is valid."""
    return "@" in email and "." in email.split("@")[1]


@pytest.mark.parametrize("email,expected", [
    ("user@example.com", True),
    ("test.user@domain.co.uk", True),
    ("invalid.email", False),
    ("@example.com", False),
    ("user@domain", False),
    ("", False),
])
def test_email_validation(email, expected):
    """Test email validation with various inputs."""
    assert is_valid_email(email) == expected


@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (0, 0, 0),
    (-1, 1, 0),
    (100, 200, 300),
    (-5, -5, -10),
])
def test_addition_parameterized(a, b, expected):
    """Test addition with multiple parameter sets."""
    from test_calculator import Calculator
    calc = Calculator()
    assert calc.add(a, b) == expected


# Using pytest.param for special cases
@pytest.mark.parametrize("value,expected", [
    pytest.param(1, True, id="positive"),
    pytest.param(0, False, id="zero"),
    pytest.param(-1, False, id="negative"),
])
def test_is_positive(value, expected):
    """Test with custom test IDs."""
    assert (value > 0) == expected
```

### Pattern 4: Mocking with unittest.mock

```python
# test_api_client.py
import pytest
from unittest.mock import Mock, patch, MagicMock
import requests

class APIClient:
    """Simple API client."""

    def __init__(self, base_url: str):
        self.base_url = base_url

    def get_user(self, user_id: int) -> dict:
        """Fetch user from API."""
        response = requests.get(f"{self.base_url}/users/{user_id}")
        response.raise_for_status()
        return response.json()

    def create_user(self, data: dict) -> dict:
        """Create new user."""
        response = requests.post(f"{self.base_url}/users", json=data)
        response.raise_for_status()
        return response.json()


def test_get_user_success():
    """Test successful API call with mock."""
    client = APIClient("https://api.example.com")

    mock_response = Mock()
    mock_response.json.return_value = {"id": 1, "name": "John Doe"}
    mock_response.raise_for_status.return_value = None

    with patch("requests.get", return_value=mock_response) as mock_get:
        user = client.get_user(1)

        assert user["id"] == 1
        assert user["name"] == "John Doe"
        mock_get.assert_called_once_with("https://api.example.com/users/1")


def test_get_user_not_found():
    """Test API call with 404 error."""
    client = APIClient("https://api.example.com")

    mock_response = Mock()
    mock_response.raise_for_status.side_effect = requests.HTTPError("404 Not Found")

    with patch("requests.get", return_value=mock_response):
        with pytest.raises(requests.HTTPError):
            client.get_user(999)


@patch("requests.post")
def test_create_user(mock_post):
    """Test user creation with decorator syntax."""
    client = APIClient("https://api.example.com")

    mock_post.return_value.json.return_value = {"id": 2, "name": "Jane Doe"}
    mock_post.return_value.raise_for_status.return_value = None

    user_data = {"name": "Jane Doe", "email": "jane@example.com"}
    result = client.create_user(user_data)

    assert result["id"] == 2
    mock_post.assert_called_once()
    call_args = mock_post.call_args
    assert call_args.kwargs["json"] == user_data
```

### Pattern 5: Testing Exceptions

```python
# test_exceptions.py
import pytest

def divide(a: float, b: float) -> float:
    """Divide a by b."""
    if b == 0:
        raise ZeroDivisionError("Division by zero")
    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
        raise TypeError("Arguments must be numbers")
    return a / b


def test_zero_division():
    """Test exception is raised for division by zero."""
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)


def test_zero_division_with_message():
    """Test exception message."""
    with pytest.raises(ZeroDivisionError, match="Division by zero"):
        divide(5, 0)


def test_type_error():
    """Test type error exception."""
    with pytest.raises(TypeError, match="must be numbers"):
        divide("10", 5)


def test_exception_info():
    """Test accessing exception info."""
    with pytest.raises(ValueError) as exc_info:
        int("not a number")

    assert "invalid literal" in str(exc_info.value)
```

## Advanced Patterns

### Pattern 6: Testing Async Code

```python
# test_async.py
import pytest
import asyncio

async def fetch_data(url: str) -> dict:
    """Fetch data asynchronously."""
    await asyncio.sleep(0.1)
    return {"url": url, "data": "result"}


@pytest.mark.asyncio
async def test_fetch_data():
    """Test async function."""
    result = await fetch_data("https://api.example.com")
    assert result["url"] == "https://api.example.com"
    assert "data" in result


@pytest.mark.asyncio
async def test_concurrent_fetches():
    """Test concurrent async operations."""
    urls = ["url1", "url2", "url3"]
    tasks = [fetch_data(url) for url in urls]
    results = await asyncio.gather(*tasks)

    assert len(results) == 3
    assert all("data" in r for r in results)


@pytest.fixture
async def async_client():
    """Async fixture."""
    client = {"connected": True}
    yield client
    client["connected"] = False


@pytest.mark.asyncio
async def test_with_async_fixture(async_client):
    """Test using async fixture."""
    assert async_client["connected"] is True
```

### Pattern 7: Monkeypatch for Testing

```python
# test_environment.py
import os
import pytest

def get_database_url() -> str:
    """Get database URL from environment."""
    return os.environ.get("DATABASE_URL", "sqlite:///:memory:")


def test_database_url_default():
    """Test default database URL."""
    # Will use actual environment variable if set
    url = get_database_url()
    assert url


def test_database_url_custom(monkeypatch):
    """Test custom database URL with monkeypatch."""
    monkeypatch.setenv("DATABASE_URL", "postgresql://localhost/test")
    assert get_database_url() == "postgresql://localhost/test"


def test_database_url_not_set(monkeypatch):
    """Test when env var is not set."""
    monkeypatch.delenv("DATABASE_URL", raising=False)
    assert get_database_url() == "sqlite:///:memory:"


class Config:
    """Configuration class."""

    def __init__(self):
        self.api_key = "production-key"

    def get_api_key(self):
        return self.api_key


def test_monkeypatch_attribute(monkeypatch):
    """Test monkeypatching object attributes."""
    config = Config()
    monkeypatch.setattr(config, "api_key", "test-key")
    assert config.get_api_key() == "test-key"
```

### Pattern 8: Temporary Files and Directories

```python
# test_file_operations.py
import pytest
from pathlib import Path

def save_data(filepath: Path, data: str):
    """Save data to file."""
    filepath.write_text(data)


def load_data(filepath: Path) -> str:
    """Load data from file."""
    return filepath.read_text()


def test_file_operations(tmp_path):
    """Test file operations with temporary directory."""
    # tmp_path is a pathlib.Path object
    test_file = tmp_path / "test_data.txt"

    # Save data
    save_data(test_file, "Hello, World!")

    # Verify file exists
    assert test_file.exists()

    # Load and verify data
    data = load_data(test_file)
    assert data == "Hello, World!"


def test_multiple_files(tmp_path):
    """Test with multiple temporary files."""
    files = {
        "file1.txt": "Content 1",
        "file2.txt": "Content 2",
        "file3.txt": "Content 3"
    }

    for filename, content in files.items():
        filepath = tmp_path / filename
        save_data(filepath, content)

    # Verify all files created
    assert len(list(tmp_path.iterdir())) == 3

    # Verify contents
    for filename, expected_content in files.items():
        filepath = tmp_path / filename
        assert load_data(filepath) == expected_content
```

### Pattern 9: Custom Fixtures and Conftest

```python
# conftest.py
"""Shared fixtures for all tests."""
import pytest

@pytest.fixture(scope="session")
def database_url():
    """Provide database URL for all tests."""
    return "postgresql://localhost/test_db"


@pytest.fixture(autouse=True)
def reset_database(database_url):
    """Auto-use fixture that runs before each test."""
    # Setup: Clear database
    print(f"Clearing database: {database_url}")
    yield
    # Teardown: Clean up
    print("Test completed")


@pytest.fixture
def sample_user():
    """Provide sample user data."""
    return {
        "id": 1,
        "name": "Test User",
        "email": "test@example.com"
    }


@pytest.fixture
def sample_users():
    """Provide list of sample users."""
    return [
        {"id": 1, "name": "User 1"},
        {"id": 2, "name": "User 2"},
        {"id": 3, "name": "User 3"},
    ]


# Parametrized fixture
@pytest.fixture(params=["sqlite", "postgresql", "mysql"])
def db_backend(request):
    """Fixture that runs tests with different database backends."""
    return request.param


def test_with_db_backend(db_backend):
    """This test will run 3 times with different backends."""
    print(f"Testing with {db_backend}")
    assert db_backend in ["sqlite", "postgresql", "mysql"]
```

### Pattern 10: Property-Based Testing

```python
# test_properties.py
from hypothesis import given, strategies as st
import pytest

def reverse_string(s: str) -> str:
    """Reverse a string."""
    return s[::-1]


@given(st.text())
def test_reverse_twice_is_original(s):
    """Property: reversing twice returns original."""
    assert reverse_string(reverse_string(s)) == s


@given(st.text())
def test_reverse_length(s):
    """Property: reversed string has same length."""
    assert len(reverse_string(s)) == len(s)


@given(st.integers(), st.integers())
def test_addition_commutative(a, b):
    """Property: addition is commutative."""
    assert a + b == b + a


@given(st.lists(st.integers()))
def test_sorted_list_properties(lst):
    """Property: sorted list is ordered."""
    sorted_lst = sorted(lst)

    # Same length
    assert len(sorted_lst) == len(lst)

    # All elements present
    assert set(sorted_lst) == set(lst)

    # Is ordered
    for i in range(len(sorted_lst) - 1):
        assert sorted_lst[i] <= sorted_lst[i + 1]
```

## Testing Best Practices

### Test Organization

```python
# tests/
#   __init__.py
#   conftest.py           # Shared fixtures
#   test_unit/            # Unit tests
#     test_models.py
#     test_utils.py
#   test_integration/     # Integration tests
#     test_api.py
#     test_database.py
#   test_e2e/            # End-to-end tests
#     test_workflows.py
```

### Test Naming

```python
# Good test names
def test_user_creation_with_valid_data():
    """Clear name describes what is being tested."""
    pass


def test_login_fails_with_invalid_password():
    """Name describes expected behavior."""
    pass


def test_api_returns_404_for_missing_resource():
    """Specific about inputs and expected outcomes."""
    pass


# Bad test names
def test_1():  # Not descriptive
    pass


def test_user():  # Too vague
    pass


def test_function():  # Doesn't explain what's tested
    pass
```

### Test Markers

```python
# test_markers.py
import pytest

@pytest.mark.slow
def test_slow_operation():
    """Mark slow tests."""
    import time
    time.sleep(2)


@pytest.mark.integration
def test_database_integration():
    """Mark integration tests."""
    pass


@pytest.mark.skip(reason="Feature not implemented yet")
def test_future_feature():
    """Skip tests temporarily."""
    pass


@pytest.mark.skipif(os.name == "nt", reason="Unix only test")
def test_unix_specific():
    """Conditional skip."""
    pass


@pytest.mark.xfail(reason="Known bug #123")
def test_known_bug():
    """Mark expected failures."""
    assert False


# Run with:
# pytest -m slow          # Run only slow tests
# pytest -m "not slow"    # Skip slow tests
# pytest -m integration   # Run integration tests
```

### Coverage Reporting

```bash
# Install coverage
pip install pytest-cov

# Run tests with coverage
pytest --cov=myapp tests/

# Generate HTML report
pytest --cov=myapp --cov-report=html tests/

# Fail if coverage below threshold
pytest --cov=myapp --cov-fail-under=80 tests/

# Show missing lines
pytest --cov=myapp --cov-report=term-missing tests/
```

## Testing Database Code

```python
# test_database_models.py
import pytest
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session

Base = declarative_base()


class User(Base):
    """User model."""
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    name = Column(String(50))
    email = Column(String(100), unique=True)


@pytest.fixture(scope="function")
def db_session() -> Session:
    """Create in-memory database for testing."""
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)

    SessionLocal = sessionmaker(bind=engine)
    session = SessionLocal()

    yield session

    session.close()


def test_create_user(db_session):
    """Test creating a user."""
    user = User(name="Test User", email="test@example.com")
    db_session.add(user)
    db_session.commit()

    assert user.id is not None
    assert user.name == "Test User"


def test_query_user(db_session):
    """Test querying users."""
    user1 = User(name="User 1", email="user1@example.com")
    user2 = User(name="User 2", email="user2@example.com")

    db_session.add_all([user1, user2])
    db_session.commit()

    users = db_session.query(User).all()
    assert len(users) == 2


def test_unique_email_constraint(db_session):
    """Test unique email constraint."""
    from sqlalchemy.exc import IntegrityError

    user1 = User(name="User 1", email="same@example.com")
    user2 = User(name="User 2", email="same@example.com")

    db_session.add(user1)
    db_session.commit()

    db_session.add(user2)

    with pytest.raises(IntegrityError):
        db_session.commit()
```

## CI/CD Integration

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        python-version: ["3.9", "3.10", "3.11", "3.12"]

    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}

      - name: Install dependencies
        run: |
          pip install -e ".[dev]"
          pip install pytest pytest-cov

      - name: Run tests
        run: |
          pytest --cov=myapp --cov-report=xml

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml
```

## Configuration Files

```ini
# pytest.ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts =
    -v
    --strict-markers
    --tb=short
    --cov=myapp
    --cov-report=term-missing
markers =
    slow: marks tests as slow
    integration: marks integration tests
    unit: marks unit tests
    e2e: marks end-to-end tests
```

```toml
# pyproject.toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = [
    "-v",
    "--cov=myapp",
    "--cov-report=term-missing",
]

[tool.coverage.run]
source = ["myapp"]
omit = ["*/tests/*", "*/migrations/*"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
]
```

## Resources

- **pytest documentation**: <https://docs.pytest.org/>
- **unittest.mock**: <https://docs.python.org/3/library/unittest.mock.html>
- **hypothesis**: Property-based testing
- **pytest-asyncio**: Testing async code
- **pytest-cov**: Coverage reporting
- **pytest-mock**: pytest wrapper for mock

## Best Practices Summary

1. **Write tests first** (TDD) or alongside code
2. **One assertion per test** when possible
3. **Use descriptive test names** that explain behavior
4. **Keep tests independent** and isolated
5. **Use fixtures** for setup and teardown
6. **Mock external dependencies** appropriately
7. **Parametrize tests** to reduce duplication
8. **Test edge cases** and error conditions
9. **Measure coverage** but focus on quality
10. **Run tests in CI/CD** on every commit

## Uv Package Manager

# UV Package Manager

Comprehensive guide to using uv, an extremely fast Python package installer and resolver written in Rust, for modern Python project management and dependency workflows.

## When to Use This Skill

- Setting up new Python projects quickly
- Managing Python dependencies faster than pip
- Creating and managing virtual environments
- Installing Python interpreters
- Resolving dependency conflicts efficiently
- Migrating from pip/pip-tools/poetry
- Speeding up CI/CD pipelines
- Managing monorepo Python projects
- Working with lockfiles for reproducible builds
- Optimizing Docker builds with Python dependencies

## Core Concepts

### 1. What is uv?

- **Ultra-fast package installer**: 10-100x faster than pip
- **Written in Rust**: Leverages Rust's performance
- **Drop-in pip replacement**: Compatible with pip workflows
- **Virtual environment manager**: Create and manage venvs
- **Python installer**: Download and manage Python versions
- **Resolver**: Advanced dependency resolution
- **Lockfile support**: Reproducible installations

### 2. Key Features

- Blazing fast installation speeds
- Disk space efficient with global cache
- Compatible with pip, pip-tools, poetry
- Comprehensive dependency resolution
- Cross-platform support (Linux, macOS, Windows)
- No Python required for installation
- Built-in virtual environment support

### 3. UV vs Traditional Tools

- **vs pip**: 10-100x faster, better resolver
- **vs pip-tools**: Faster, simpler, better UX
- **vs poetry**: Faster, less opinionated, lighter
- **vs conda**: Faster, Python-focused

## Installation

### Quick Install

```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows (PowerShell)
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Using pip (if you already have Python)
pip install uv

# Using Homebrew (macOS)
brew install uv

# Using cargo (if you have Rust)
cargo install --git https://github.com/astral-sh/uv uv
```

### Verify Installation

```bash
uv --version
# uv 0.x.x
```

## Quick Start

### Create a New Project

```bash
# Create new project with virtual environment
uv init my-project
cd my-project

# Or create in current directory
uv init .

# Initialize creates:
# - .python-version (Python version)
# - pyproject.toml (project config)
# - README.md
# - .gitignore
```

### Install Dependencies

```bash
# Install packages (creates venv if needed)
uv add requests pandas

# Install dev dependencies
uv add --dev pytest black ruff

# Install from requirements.txt
uv pip install -r requirements.txt

# Install from pyproject.toml
uv sync
```

## Virtual Environment Management

### Pattern 1: Creating Virtual Environments

```bash
# Create virtual environment with uv
uv venv

# Create with specific Python version
uv venv --python 3.12

# Create with custom name
uv venv my-env

# Create with system site packages
uv venv --system-site-packages

# Specify location
uv venv /path/to/venv
```

### Pattern 2: Activating Virtual Environments

```bash
# Linux/macOS
source .venv/bin/activate

# Windows (Command Prompt)
.venv\Scripts\activate.bat

# Windows (PowerShell)
.venv\Scripts\Activate.ps1

# Or use uv run (no activation needed)
uv run python script.py
uv run pytest
```

### Pattern 3: Using uv run

```bash
# Run Python script (auto-activates venv)
uv run python app.py

# Run installed CLI tool
uv run black .
uv run pytest

# Run with specific Python version
uv run --python 3.11 python script.py

# Pass arguments
uv run python script.py --arg value
```

## Package Management

### Pattern 4: Adding Dependencies

```bash
# Add package (adds to pyproject.toml)
uv add requests

# Add with version constraint
uv add "django>=4.0,<5.0"

# Add multiple packages
uv add numpy pandas matplotlib

# Add dev dependency
uv add --dev pytest pytest-cov

# Add optional dependency group
uv add --optional docs sphinx

# Add from git
uv add git+https://github.com/user/repo.git

# Add from git with specific ref
uv add git+https://github.com/user/repo.git@v1.0.0

# Add from local path
uv add ./local-package

# Add editable local package
uv add -e ./local-package
```

### Pattern 5: Removing Dependencies

```bash
# Remove package
uv remove requests

# Remove dev dependency
uv remove --dev pytest

# Remove multiple packages
uv remove numpy pandas matplotlib
```

### Pattern 6: Upgrading Dependencies

```bash
# Upgrade specific package
uv add --upgrade requests

# Upgrade all packages
uv sync --upgrade

# Upgrade package to latest
uv add --upgrade requests

# Show what would be upgraded
uv tree --outdated
```

### Pattern 7: Locking Dependencies

```bash
# Generate uv.lock file
uv lock

# Update lock file
uv lock --upgrade

# Lock without installing
uv lock --no-install

# Lock specific package
uv lock --upgrade-package requests
```

## Python Version Management

### Pattern 8: Installing Python Versions

```bash
# Install Python version
uv python install 3.12

# Install multiple versions
uv python install 3.11 3.12 3.13

# Install latest version
uv python install

# List installed versions
uv python list

# Find available versions
uv python list --all-versions
```

### Pattern 9: Setting Python Version

```bash
# Set Python version for project
uv python pin 3.12

# This creates/updates .python-version file

# Use specific Python version for command
uv --python 3.11 run python script.py

# Create venv with specific version
uv venv --python 3.12
```

## Project Configuration

### Pattern 10: pyproject.toml with uv

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "My awesome project"
readme = "README.md"
requires-python = ">=3.8"
dependencies = [
    "requests>=2.31.0",
    "pydantic>=2.0.0",
    "click>=8.1.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "black>=23.0.0",
    "ruff>=0.1.0",
    "mypy>=1.5.0",
]
docs = [
    "sphinx>=7.0.0",
    "sphinx-rtd-theme>=1.3.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv]
dev-dependencies = [
    # Additional dev dependencies managed by uv
]

[tool.uv.sources]
# Custom package sources
my-package = { git = "https://github.com/user/repo.git" }
```

### Pattern 11: Using uv with Existing Projects

```bash
# Migrate from requirements.txt
uv add -r requirements.txt

# Migrate from poetry
# Already have pyproject.toml, just use:
uv sync

# Export to requirements.txt
uv pip freeze > requirements.txt

# Export with hashes
uv pip freeze --require-hashes > requirements.txt
```

## Advanced Workflows

### Pattern 12: Monorepo Support

```bash
# Project structure
# monorepo/
#   packages/
#     package-a/
#       pyproject.toml
#     package-b/
#       pyproject.toml
#   pyproject.toml (root)

# Root pyproject.toml
[tool.uv.workspace]
members = ["packages/*"]

# Install all workspace packages
uv sync

# Add workspace dependency
uv add --path ./packages/package-a
```

### Pattern 13: CI/CD Integration

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v2
        with:
          enable-cache: true

      - name: Set up Python
        run: uv python install 3.12

      - name: Install dependencies
        run: uv sync --all-extras --dev

      - name: Run tests
        run: uv run pytest

      - name: Run linting
        run: |
          uv run ruff check .
          uv run black --check .
```

### Pattern 14: Docker Integration

```dockerfile
# Dockerfile
FROM python:3.12-slim

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Copy application code
COPY . .

# Run application
CMD ["uv", "run", "python", "app.py"]
```

**Optimized multi-stage build:**

```dockerfile
# Multi-stage Dockerfile
FROM python:3.12-slim AS builder

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Install dependencies to venv
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-editable

# Runtime stage
FROM python:3.12-slim

WORKDIR /app

# Copy venv from builder
COPY --from=builder /app/.venv .venv
COPY . .

# Use venv
ENV PATH="/app/.venv/bin:$PATH"

CMD ["python", "app.py"]
```

### Pattern 15: Lockfile Workflows

```bash
# Create lockfile (uv.lock)
uv lock

# Install from lockfile (exact versions)
uv sync --frozen

# Update lockfile without installing
uv lock --no-install

# Upgrade specific package in lock
uv lock --upgrade-package requests

# Check if lockfile is up to date
uv lock --check

# Export lockfile to requirements.txt
uv export --format requirements-txt > requirements.txt

# Export with hashes for security
uv export --format requirements-txt --hash > requirements.txt
```

## Performance Optimization

### Pattern 16: Using Global Cache

```bash
# UV automatically uses global cache at:
# Linux: ~/.cache/uv
# macOS: ~/Library/Caches/uv
# Windows: %LOCALAPPDATA%\uv\cache

# Clear cache
uv cache clean

# Check cache size
uv cache dir
```

### Pattern 17: Parallel Installation

```bash
# UV installs packages in parallel by default

# Control parallelism
uv pip install --jobs 4 package1 package2

# No parallel (sequential)
uv pip install --jobs 1 package
```

### Pattern 18: Offline Mode

```bash
# Install from cache only (no network)
uv pip install --offline package

# Sync from lockfile offline
uv sync --frozen --offline
```

## Comparison with Other Tools

### uv vs pip

```bash
# pip
python -m venv .venv
source .venv/bin/activate
pip install requests pandas numpy
# ~30 seconds

# uv
uv venv
uv add requests pandas numpy
# ~2 seconds (10-15x faster)
```

### uv vs poetry

```bash
# poetry
poetry init
poetry add requests pandas
poetry install
# ~20 seconds

# uv
uv init
uv add requests pandas
uv sync
# ~3 seconds (6-7x faster)
```

### uv vs pip-tools

```bash
# pip-tools
pip-compile requirements.in
pip-sync requirements.txt
# ~15 seconds

# uv
uv lock
uv sync --frozen
# ~2 seconds (7-8x faster)
```

## Common Workflows

### Pattern 19: Starting a New Project

```bash
# Complete workflow
uv init my-project
cd my-project

# Set Python version
uv python pin 3.12

# Add dependencies
uv add fastapi uvicorn pydantic

# Add dev dependencies
uv add --dev pytest black ruff mypy

# Create structure
mkdir -p src/my_project tests

# Run tests
uv run pytest

# Format code
uv run black .
uv run ruff check .
```

### Pattern 20: Maintaining Existing Project

```bash
# Clone repository
git clone https://github.com/user/project.git
cd project

# Install dependencies (creates venv automatically)
uv sync

# Install with dev dependencies
uv sync --all-extras

# Update dependencies
uv lock --upgrade

# Run application
uv run python app.py

# Run tests
uv run pytest

# Add new dependency
uv add new-package

# Commit updated files
git add pyproject.toml uv.lock
git commit -m "Add new-package dependency"
```

## Tool Integration

### Pattern 21: Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: uv-lock
        name: uv lock
        entry: uv lock
        language: system
        pass_filenames: false

      - id: ruff
        name: ruff
        entry: uv run ruff check --fix
        language: system
        types: [python]

      - id: black
        name: black
        entry: uv run black
        language: system
        types: [python]
```

### Pattern 22: VS Code Integration

```json
// .vscode/settings.json
{
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python",
  "python.terminal.activateEnvironment": true,
  "python.testing.pytestEnabled": true,
  "python.testing.pytestArgs": ["-v"],
  "python.linting.enabled": true,
  "python.formatting.provider": "black",
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true
  }
}
```

## Troubleshooting

### Common Issues

```bash
# Issue: uv not found
# Solution: Add to PATH or reinstall
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc

# Issue: Wrong Python version
# Solution: Pin version explicitly
uv python pin 3.12
uv venv --python 3.12

# Issue: Dependency conflict
# Solution: Check resolution
uv lock --verbose

# Issue: Cache issues
# Solution: Clear cache
uv cache clean

# Issue: Lockfile out of sync
# Solution: Regenerate
uv lock --upgrade
```

## Best Practices

### Project Setup

1. **Always use lockfiles** for reproducibility
2. **Pin Python version** with .python-version
3. **Separate dev dependencies** from production
4. **Use uv run** instead of activating venv
5. **Commit uv.lock** to version control
6. **Use --frozen in CI** for consistent builds
7. **Leverage global cache** for speed
8. **Use workspace** for monorepos
9. **Export requirements.txt** for compatibility
10. **Keep uv updated** for latest features

### Performance Tips

```bash
# Use frozen installs in CI
uv sync --frozen

# Use offline mode when possible
uv sync --offline

# Parallel operations (automatic)
# uv does this by default

# Reuse cache across environments
# uv shares cache globally

# Use lockfiles to skip resolution
uv sync --frozen  # skips resolution
```

## Migration Guide

### From pip + requirements.txt

```bash
# Before
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# After
uv venv
uv pip install -r requirements.txt
# Or better:
uv init
uv add -r requirements.txt
```

### From Poetry

```bash
# Before
poetry install
poetry add requests

# After
uv sync
uv add requests

# Keep existing pyproject.toml
# uv reads [project] and [tool.poetry] sections
```

### From pip-tools

```bash
# Before
pip-compile requirements.in
pip-sync requirements.txt

# After
uv lock
uv sync --frozen
```

## Command Reference

### Essential Commands

```bash
# Project management
uv init [PATH]              # Initialize project
uv add PACKAGE              # Add dependency
uv remove PACKAGE           # Remove dependency
uv sync                     # Install dependencies
uv lock                     # Create/update lockfile

# Virtual environments
uv venv [PATH]              # Create venv
uv run COMMAND              # Run in venv

# Python management
uv python install VERSION   # Install Python
uv python list              # List installed Pythons
uv python pin VERSION       # Pin Python version

# Package installation (pip-compatible)
uv pip install PACKAGE      # Install package
uv pip uninstall PACKAGE    # Uninstall package
uv pip freeze               # List installed
uv pip list                 # List packages

# Utility
uv cache clean              # Clear cache
uv cache dir                # Show cache location
uv --version                # Show version
```

## Resources

- **Official documentation**: <https://docs.astral.sh/uv/>
- **GitHub repository**: <https://github.com/astral-sh/uv>
- **Astral blog**: <https://astral.sh/blog>
- **Migration guides**: <https://docs.astral.sh/uv/guides/>
- **Comparison with other tools**: <https://docs.astral.sh/uv/pip/compatibility/>

## Best Practices Summary

1. **Use uv for all new projects** - Start with `uv init`
2. **Commit lockfiles** - Ensure reproducible builds
3. **Pin Python versions** - Use .python-version
4. **Use uv run** - Avoid manual venv activation
5. **Leverage caching** - Let uv manage global cache
6. **Use --frozen in CI** - Exact reproduction
7. **Keep uv updated** - Fast-moving project
8. **Use workspaces** - For monorepo projects
9. **Export for compatibility** - Generate requirements.txt when needed
10. **Read the docs** - uv is feature-rich and evolving
