
### Architecture

- MVP design pattern used
- Coordination pattern used
- Added initial coordinator for injecting presenter

### Features

- Supports portrait and landscape modes
- Handled different states: loading, success, empty, error
- Image Loader used to download image asyncronously 
    Supports in-memory caching (not in disk)
    Support cancellation of image download when cell is not visible
- Code coverage is maximum using MVP pattern

### Areas of improvement

- Needs improvement in Image Loader
    Can create a different classes for storing cache and ongoing task
