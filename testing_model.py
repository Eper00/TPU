import torch
import matplotlib.pyplot as plt
from torch.utils.data import DataLoader
from model import MLP,MNISTDataset



def quantize_weights(weights, num_bits=8):
    scale = 2**(num_bits - 1) - 1  # 127, ha 8 bites előjeles értékeket használunk
    quantized_weights = torch.round(weights * scale)
    return quantized_weights.int()  # Egészként tárolás
model = MLP()

model.load_state_dict(torch.load('mnist_mlp.pt'))
model.eval()  

print("Modell betöltve!")

transform = None 
test_data = MNISTDataset('mnist/t10k-images-idx3-ubyte.gz', 'mnist/t10k-labels-idx1-ubyte.gz', transform=transform)
test_loader = DataLoader(test_data, batch_size=64, shuffle=False)

correct = 0
total = 0
correct_images = []
incorrect_images = []


with torch.no_grad():
    for images, labels in test_loader:
        outputs = model(images)
        _, predicted = torch.max(outputs, 1)
        total += labels.size(0)
        correct += (predicted == labels).sum().item()

        # Helyes és helytelen képek gyűjtése
        for i in range(images.size(0)):
            image = images[i].view(28, 28).numpy()
            label = labels[i].item()
            pred = predicted[i].item()
            
            if pred == label:
                correct_images.append((image, label))
            else:
                incorrect_images.append((image, label, pred))

# Pontosság
accuracy = 100 * correct / total
print(f'Teszt pontosság: {accuracy:.2f}%')

# Képek vizualizálása
def visualize_images(correct_images, incorrect_images):
    # Helyes képek
    if correct_images:
        plt.figure(figsize=(12, 6))
        for i in range(min(10, len(correct_images))):  # Az első 5 helyes képet jelenítjük meg
            plt.subplot(2, 5, i + 1)
            plt.imshow(correct_images[i][0], cmap='gray')
            plt.title(f'Label: {correct_images[i][1]}', fontsize=12)
            plt.axis('off')
        plt.suptitle('Helyesen kategorizált képek', fontsize=14)
        plt.show()

    # Helytelen képek
    if incorrect_images:
        plt.figure(figsize=(12, 6))
        for i in range(min(10, len(incorrect_images))):  # Az első 5 helytelen képet jelenítjük meg
            plt.subplot(2, 5, i + 1)
            plt.imshow(incorrect_images[i][0], cmap='gray')
            plt.title(f'Label: {incorrect_images[i][1]} | Pred: {incorrect_images[i][2]}', fontsize=12)
            plt.axis('off')
        plt.suptitle('Helytelenül kategorizált képek', fontsize=14)
        plt.show()

# Vizualizálás
weights = model.fc1.weight.detach()
quantized_weights = quantize_weights(weights)

print("Eredeti súlytartomány:", weights.min().item(), "->", weights.max().item())
print("Kvantált súlytartomány:", quantized_weights.min().item(), "->", quantized_weights.max().item())

