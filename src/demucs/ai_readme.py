from rich import print
import ollama

with open("README.txt", "r") as f:
    readme = f.read()

print("\n[bold yellow]EBYS AI READY (README MODE)[/bold yellow]\n")

while True:
    question = input("You: ")

    if question.lower() in ["exit", "quit"]:
        break

    response = ollama.chat(
        model="llama3.1",
        messages=[
            {
                "role": "user",
                "content": f"""
PROJECT CONTEXT:
{readme}

QUESTION:
{question}
"""
            }
        ]
    )

    print("\n[green]Cricket:[/green]", response["message"]["content"], "\n")
