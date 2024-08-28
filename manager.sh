#!/bin/bash

# Function to install Docker using Snap
install_docker() {
    echo "Docker is not installed. Installing Docker using Snap..."
    sudo snap install docker
    echo "Docker has been installed."
}

# Function to select profile
select_profile() {
    while true; do
        echo "Please select a profile (uat/sit):"
        read profile
        case $profile in
            uat|sit)
                echo "Selected profile: $profile"
                return
                ;;
            *)
                echo "Invalid option. Please enter 'uat' or 'sit'."
                ;;
        esac
    done
}

# Function to run Docker Compose commands
run_docker_compose() {
    local command=$1
    shift
    sudo docker compose --profile $profile --env-file $env_file $command "$@"
}

# Main script execution
echo "Starting Docker management script"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    install_docker
fi

# Prompt the user for profile
select_profile

# Set environment file based on selection
env_file=".env.$profile"

# Main loop for continuous operation
while true; do
    # Prompt the user for action
    echo "Please enter an option (build, start, stop, clean, rebuild, log or exit):"
    read option

    # Execute corresponding commands based on the user's input
    case $option in
        build)
            echo "Building the Docker image for $profile profile..."
            run_docker_compose build
            ;;
        start)
            echo "Starting the Docker Compose application for $profile profile..."
            run_docker_compose up -d
            ;;
        stop)
            echo "Stopping the Docker Compose application for $profile profile..."
            run_docker_compose down
            ;;
        clean)
            echo "Cleaning all Docker resources..."
            sudo docker system prune -a
            ;;
        rebuild)
            echo "Rebuilding the Docker image and restarting the container for $profile profile..."
            run_docker_compose build
            run_docker_compose down
            run_docker_compose up -d
            ;;
        log)
            echo "Displaying the logs of the Docker Compose application for $profile profile..."
            run_docker_compose logs -f
            ;;
        exit)
            echo "Exiting the script..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please enter build, start, stop, clean, rebuild, log or exit."
            ;;
    esac

    echo "Command executed. Ready for next action."
done

echo "Script execution completed."
