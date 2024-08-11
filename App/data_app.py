import gradio as gr
import skops.io as sio

# # First, load the model without trusting any types
# pipe = sio.load("./Model/drug_pipeline.skops", trusted=[])

# # Then, get the list of untrusted types
# untrusted_types = sio.get_untrusted_types()

# # Review and trust the necessary types
# pipe = sio.load("./Model/drug_pipeline.skops", trusted=untrusted_types)
# List of types that need to be trusted based on the exception
trusted_types = ["numpy.dtype"]

# Load the model with these types trusted
pipe = sio.load("./Model/drug_pipeline.skops", trusted=trusted_types)
def predict_drug(age, sex, blood_pressure, cholesterol, na_to_k_ratio):
    """Predict drugs based on patient features.

    Args:
        age (int): Age of patient
        sex (str): Sex of patient
        blood_pressure (str): Blood pressure level
        cholesterol (str): Cholesterol level
        na_to_k_ratio (float): Ratio of sodium to potassium in blood

    Returns:
        str: Predicted drug label
    """
    features = [age, sex, blood_pressure, cholesterol, na_to_k_ratio]
    predicted_drug = pipe.predict([features])[0]

    label = f"Predicted Drug: {predicted_drug}"
    return label


inputs = [
    gr.Slider(15, 74, step=1, label="Age"),
    gr.Radio(["M", "F"], label="Sex"),
    gr.Radio(["HIGH", "LOW", "NORMAL"], label="Blood Pressure"),
    gr.Radio(["HIGH", "NORMAL"], label="Cholesterol"),
    gr.Slider(6.2, 38.2, step=0.1, label="Na_to_K"),
]
outputs = [gr.Label(num_top_classes=5)]

examples = [
    [30, "M", "HIGH", "NORMAL", 15.4],
    [35, "F", "LOW", "NORMAL", 8],
    [50, "M", "HIGH", "HIGH", 34],
]


title = "Drug Classification"
description = "Enter the details to correctly identify Drug type?"
# article = "This app is a part of CI/CD learning Curriculum of MLOps"


gr.Interface(
    fn=predict_drug,
    inputs=inputs,
    outputs=outputs,
    examples=examples,
    title=title,
    description=description,
    #article=article,
    theme=gr.themes.Soft(),
).launch()