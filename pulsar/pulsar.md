# Pulsar Best Practices

## Core Principles
1. **Idempotency**: Design tasks to be safely retryable
2. **Observability**: Include progress reporting and logging
3. **Resource Management**: Set appropriate timeouts and resource limits

## Implementation Guidelines

### Task Design
```python
# Good - Idempotent task with progress reporting
def process_data(data_id: str):
    if check_if_processed(data_id):
        return {"status": "already_complete"}
        
    update_progress(20)
    # Process data
    update_progress(80)
    mark_complete(data_id)
```

### Error Handling
- Use exponential backoff for retries
- Implement dead letter queues for failed tasks
- Include comprehensive logging

### Performance
- Batch small tasks
- Use appropriate queue priorities
- Monitor queue depths

## Monitoring Setup
1. Track:
- Task completion rates
- Average processing time
- Failure rates
2. Set alerts for:
- Queue backlog
- Worker availability
- Error spikes
