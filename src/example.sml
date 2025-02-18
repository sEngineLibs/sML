// комментарии обозначаются знаком "//"

// импорт типов
import se.ui.UIScene
import se.ui.elements.shapes.Rectangle
// можно давать псевдонимы
import se.ui.elements.TextElement as Text

// для создания объекта нужно написать его тип, имя и присвоить поля
UIScene scene {
    // присваивание полей класса происходит как *имя поля*: *значение поля*
    a: 1.0
    // сложные поля класса (поля полей) присваиваются так
    layout.alignment: Center
    layout.fillWidth: true
    // если нужно присвоить сложное значение, вызвав конструктор класса, то нужно присвоить аргументы конструктора через запятую
    layout: Center, true // -> layout = new Layout(Center, true)
    // если нужно присвоить пустой сложный объект и потом задать ему определенные поля, то нужно передать их анонимным объектом
    layout: {
        alignment: Center
        fillWidth: true
    }

    // для определения дочерних объектов нужно определить объект внутри другого объекта
    Rectangle child1 {
        b: 2.0
        c: false
        d: "Hello!"
    }

    Rectangle child2 {
        b: 1.0
        c: true
        d: "Goodbye!"
    }

    Text child3 {
        text: "Text"
    }
}
