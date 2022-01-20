export function normalizeBoolean(value) {
    return typeof value === 'string' || !!value;
}

export function getToday()
{
    //return new Date().toLocaleDateString();
    var q = new Date();
    var m = q.getMonth();
    var d = q.getDate();
    var y = q.getFullYear();

    return new Date(y,m,d);
}

export function getDate(dateValue)
{
    if (dateValue === undefined) return getToday();
    const a = dateValue.split('-');
    return new Date(a[0], a[1] - 1, a[2]);
}

export function getNumberOfDays(start, end)
{

    if (start === undefined || start === null || start === '' || end === undefined || end === null || end === '') return 'N/A';

    const date1 = new Date(start);
    const date2 = new Date(end);

    // One day in milliseconds
    const oneDay = 1000 * 60 * 60 * 24;

    // Calculating the time difference between two dates
    const diffInTime = date2.getTime() - date1.getTime();

    // Calculating the no. of days between two dates
    const diffInDays = Math.round(diffInTime / oneDay); //Math.ceil

    // same day returns -1 due to created time, so return zero
    return diffInDays <= 0 ? 0 : diffInDays;
}

export function isSameDate(date1, date2)
{
    return date1.getMonth() == date2.getMonth() && date1.getDate() == date2.getDate() && date1.getFullYear() == date2.getFullYear();
}

export function getDateStyleClass(inputDate)
{
    //return new Date(inputDate) >= getToday() ? '' : 'past-due-date';

    if (inputDate==undefined || getDate(inputDate) == getToday() || isSameDate(getDate(inputDate), getToday()))
    {
        return '';
    } else if (getDate(inputDate) < getToday())
    {
        return 'past-due-date';
    } else {
        return 'future-date';
    }
}