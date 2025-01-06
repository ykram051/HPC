import pandas as pd
from dash import Dash, dcc, html, Input, Output, State
import dash
import plotly.graph_objects as go
import paramiko

def ssh_authenticate(email, password):
    hostname = "simlab-cluster.um6p.ma"
    port = 22
    username = email.split("@")[0]
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname, port=port, username=username, password=password, allow_agent=False, look_for_keys=False)
        ssh.close()
        return True
    except paramiko.AuthenticationException:
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False

# Load data
data = pd.read_csv('output.csv')

# Initialize Dash app
app = Dash(__name__)

# Layout of the app with login and dashboard
app.layout = html.Div(id="main-container", children=[
    # Login Page
    html.Div(id='login-page', style={'display': 'block'}, children=[
        html.Div(className='login-container', children=[
            html.H1('Login to HPC Dashboard', className='login-title'),
            html.Div([
                html.Label('Email:', className='login-label'),
                dcc.Input(id='email-input', type='email', placeholder='Enter your email', className='login-input'),
                html.Label('Password:', className='login-label'),
                dcc.Input(id='password-input', type='password', placeholder='Enter your password', className='login-input'),
                html.Button('Login', id='login-button', className='login-button'),
                html.Div(id='login-status', className='login-status'),
            ]),
        ]),
    ]),

    # Dashboard Page
    html.Div(id='dashboard-page', style={'display': 'none'}, children=[
        html.Div(className='dashboard-header', children=[
            html.H1('HPC Usage Dashboard', className='dashboard-title'),
            html.Button('Logout', id='logout-button', className='logout-button'),
            html.Div(id='welcome-message', className='welcome-message'),
        ]),
        html.Div(className='dashboard-content', children=[
            html.Div(className='dropdown-container', children=[
                html.Label('Select a user:', className='dropdown-label'),
                dcc.Dropdown(id='user-dropdown', value=None, placeholder="Select a user", className='user-dropdown'),
            ]),
            html.Div(className='card', children=[
                dcc.Graph(id='usage-pie-chart')
            ])
        ])
    ])
])

# Callback for authentication
@app.callback(
    [
        Output('login-status', 'children'),
        Output('login-page', 'style'),
        Output('dashboard-page', 'style'),
        Output('user-dropdown', 'options'),
        Output('user-dropdown', 'value'),
        Output('welcome-message', 'children')
    ],
    [Input('login-button', 'n_clicks'),
     Input('logout-button', 'n_clicks')],
    [State('email-input', 'value'),
     State('password-input', 'value')]
)
def authenticate_user(login_clicks, logout_clicks, email, password):
    ctx = dash.callback_context
    if not ctx.triggered:
        return "", {'display': 'block'}, {'display': 'none'}, [], None, ""
    
    button_id = ctx.triggered[0]['prop_id'].split('.')[0]
    
    if button_id == 'logout-button':
        return "", {'display': 'block'}, {'display': 'none'}, [], None, ""
    
    if login_clicks > 0:
        if email == 'admin@um6p.ma' and password == 'admin123':
            # Sort users alphabetically for admin
            sorted_users = sorted(data['User'].unique())
            user_options = [{'label': user, 'value': user} for user in sorted_users]
            first_user = sorted_users[0] if len(sorted_users) > 0 else None
            return "Admin logged in.", {'display': 'none'}, {'display': 'block'}, user_options, first_user, "Welcome, Administrator!"
        elif ssh_authenticate(email, password):
            username = email.split("@")[0]
            user_data = data[data['User'] == username]
            if user_data.empty:
                return "No data available for this user.", {'display': 'block'}, {'display': 'none'}, [], None, ""
            user_options = [{'label': username, 'value': username}]
            return "Login successful.", {'display': 'none'}, {'display': 'block'}, user_options, username, f"Welcome, {username}!"
        else:
            return "Invalid credentials. Please try again.", {'display': 'block'}, {'display': 'none'}, [], None, ""
    return "", {'display': 'block'}, {'display': 'none'}, [], None, ""

# Callback for updating the graph
@app.callback(
    Output('usage-pie-chart', 'figure'),
    [Input('user-dropdown', 'value')]
)
def update_pie_chart(selected_user):
    if not selected_user:
        fig = go.Figure()
        fig.update_layout(
            title_text='Please select a user to view CPU and GPU usage.',
            annotations=[dict(
                text="Please select a user",
                xref="paper",
                yref="paper",
                showarrow=False,
                font=dict(size=20)
            )]
        )
        return fig

    # Filter data for the selected user
    user_data = data[data['User'] == selected_user]

    # Calculate total CPU and GPU hours
    total_cpu_hours = user_data['CPU_Time(Hours)'].sum()
    total_gpu_hours = user_data['GPU_Time(Hours)'].sum()

    if total_cpu_hours == 0 and total_gpu_hours == 0:
        fig = go.Figure()
        fig.update_layout(
            title_text=f'Usage Statistics for {selected_user}',
            annotations=[dict(
                text="No CPU or GPU usage recorded",
                xref="paper",
                yref="paper",
                showarrow=False,
                font=dict(size=20)
            )]
        )
        return fig

    # Data for pie chart
    labels = ['CPU Time', 'GPU Time']
    values = [total_cpu_hours, total_gpu_hours]
    
    # Create a Pie chart with percentages
    fig = go.Figure(go.Pie(
        labels=labels,
        values=values,
        hole=0.3,
        textinfo='percent+label',
        marker=dict(colors=['#004aad', '#0080ff'])
    ))
    
    fig.update_layout(
        title_text=f'Resource Usage for {selected_user}',
        title_font=dict(size=24),
        showlegend=True,
        legend=dict(
            orientation="h",
            yanchor="bottom",
            y=1.02,
            xanchor="right",
            x=1
        )
    )

    return fig

if __name__ == '__main__':
    app.run_server(debug=True)