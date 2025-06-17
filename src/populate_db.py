from src.database import Base, engine, SessionLocal
from src.models import User, Profile, Post, Student, Course

# Створення таблиць
Base.metadata.create_all(bind=engine)

# Заповнення бази даних
def populate_database():
    session = SessionLocal()
    
    # Створення користувача та профілю (один до одного)
    user = User(username="john")
    profile = Profile(bio="Backend dev", user=user)
    
    # Створення постів (багато до одного)
    post1 = Post(title="First post", content="Hello, world!", author=user)
    post2 = Post(title="Second post", content="Learning SQLAlchemy", author=user)
    
    # Створення студентів і курсів (багато до багатьох)
    course1 = Course(title="Python Basics")
    course2 = Course(title="Web Development")
    student = Student(name="Alice", courses=[course1, course2])
    
    # Додавання всіх об’єктів до сесії
    session.add_all([user, profile, post1, post2, course1, course2, student])
    session.commit()
    session.close()

if __name__ == "__main__":
    populate_database()