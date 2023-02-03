Перейти в [начало] .
. Для работы с формами в приложении на |flask| будем использовать библиотеку |WTForms|
Документация доступна по ссылке [https://flask-wtf.readthedocs.io/en/1.0.x/]
Описание форм будет выполнено в виде классов, наследуемых от класса |FlaskForm|. Предварительно
необходимо импортировать все требуемые компоненты родительского класса, которые будут применяться
    | from flask_wtf import FlaskForm
    | from wtforms import StringField, BooleanField, PasswordField, SubmitField
    | from wtforms.validators import DataRequired, Email, Length

. Дальше пишем наш класс
    | class LoginForm(FlaskForm):
    |     '''Класс описывает структуру формы Login'''
    |     email = StringField("Email: ", validators=[Email()])
    |     psw = PasswordField("Пароль: ", validators=[DataRequired(), Length(min=6, max=100)])
    |     remember_me = BooleanField("Запомнить меня", default=False)
    |     submit = SubmitField("Войти", )

. В главном файле приложения необходимо обязательно импортировать созданный нами класс
    | from forms import LoginForm

. Далее пишем обработчик для страницы логин:
    | @app.route('/login', methods=['POST', 'GET'])
    | def login():
    |     '''Обработчик формы Логин'''
    |     if current_user.is_authenticated:
    |         return redirect(url_for('profile'))
    |     form = LoginForm()
    |     if form.validate_on_submit():
    |         user = d_base.get_user_by_email(form.email.data)
    |         if user and check_password_hash(user['psw'], form.psw.data):
    |             user_login = UserLogin().create(user)
    |             remember_me = form.remember_me.data
    |             login_user(user_login, remember = remember_me)
    |             return redirect(request.args.get('next') or url_for('profile'))
    |         flash("Неверная пара логин/пароль", "error")
    |     return render_template('login.html', title='Авторизация', menu=d_base.get_menu(), form=form)

. После этого необходимо внести изменения в шаблон страницы Логин
    | {% extends 'base.html' %}

    | {% block content %}
    | {{ super() }}
    | {% for cat, msg in get_flashed_messages(True) %}
    | <div class='flash {{ cat }}'>{{msg}}</div>
    | {% endfor %}
    | <form action='' method='post' class='form-contact'>
    |     <!-- Метод, содержащий скрытый токен для защиты данных формы от CSRF атак -->
    |     {{ form.hidden_tag() }}
    |     <p>{{ form.email.label() }} {{ form.email() }}
    |     <p>{{ form.psw.label() }} {{ form.psw() }}
    |     <p>{{ form.remember_me.label() }} {{ form.remember_me() }}
    |     <p>{{ form.submit() }}
    |         <hr align=left width='300px'>
    |     <p><a href="{{url_for('register')}}">Регистрация</a>
    | </form>
    | {% endblock %}