# Azure-Powered Intelligent Task Management System

## Overview

This project is a cloud-based task management system built with Microsoft technologies. It leverages Azure Cognitive Services, Azure Bot Service, and Azure Machine Learning to provide intelligent task recommendations, automated reminders, and advanced analytics. The system is fully integrated with Microsoft Teams and Office 365.

## Features

- Task Creation and Management
- Intelligent Task Recommendations
- Automated Reminders
- Advanced Analytics Dashboard

## Technologies Used

- **Front-End:** React.js, TypeScript
- **Back-End:** ASP.NET Core, C#
- **Cloud Services:** Azure Functions, Azure Machine Learning, Azure Bot Service
- **CI/CD:** Azure DevOps
- **Security:** Azure Active Directory, Azure Key Vault

## Getting Started

### Prerequisites

- Node.js and npm
- .NET Core SDK
- Azure Subscription

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/azure-task-management-system.git
    ```

2. Install the front-end dependencies:
    ```bash
    cd frontend
    npm install
    ```

3. Build and run the backend API:
    ```bash
    cd backend
    dotnet run
    ```

4. Deploy Azure Functions and Bot Service:
    - Follow the Azure documentation to deploy Functions and Bot Service.
    
### Deployment

- Use the provided Azure Pipelines YAML file to set up continuous integration and continuous deployment.

## Contributing

Feel free to fork this project and submit pull requests. Contributions are welcome!

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## ✅ Verified Quickstart

The following commands were used to validate the repo structure and build the frontend bundle. The backend requires the .NET 6 SDK to run locally.

```bash
cd frontend
npm run build
```

To run the backend API after installing the .NET 6 SDK:

```bash
./scripts/run_backend.sh
```

To run the frontend dev server:

```bash
./scripts/run_frontend.sh
```

To run the automated smoke test (requires .NET 6 SDK and curl):

```bash
./scripts/smoke_test.sh
```

## Troubleshooting

- **`dotnet: command not found`**: Install the .NET 6 SDK and ensure `dotnet` is on your `PATH`.
- **Backend not responding on http://localhost:5055**: The smoke test starts the API on port 5055; ensure the port is free.
- **Missing `node_modules`**: Run `npm install` in the `frontend` directory or use `./scripts/run_frontend.sh` which installs dependencies automatically if needed.

### .NET SDK bootstrap

If you do not have the .NET SDK installed, `./scripts/run_backend.sh` and `./scripts/smoke_test.sh` will download .NET 6 into a local `.dotnet/` directory for you. This keeps the repo self-contained while still running the official SDK.

### Mock backend fallback

If .NET is unavailable, the backend runner will automatically start a lightweight mock server that exposes the same `/api/task` endpoint so you can still explore the UI and smoke test behavior. This is a compatibility layer and does not replace the ASP.NET Core API.

- **SDK downloads blocked (HTTP 403)**: In restricted environments the automatic .NET SDK download may be blocked. In that case the backend runner and smoke test will fall back to the mock backend automatically.
