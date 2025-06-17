from src.schemas import UserSubmission

def handle_submission(data: UserSubmission):
    # Логіка обробки або збереження даних
    return {"message": f"Received data for {data.name}"}