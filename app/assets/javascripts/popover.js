$(document).on('turbolinks:load', function() {
  $('[data-popover]').wrap(function() {
    const wrapper = document.createElement('div');
    wrapper.className = 'position-relative';

    return wrapper;
  });

  $('[data-popover]').each(function(i, el) {
    const popover = wrapPopover(
      el,
      $(`[data-popover-id=${el.dataset.popover}]`).get(0),
    );
    el.parentElement.append(popover);
  });

  (function() {
    let handlerExists = false;

    $('[data-popover]').click(function(e) {
      if (!handlerExists) {
        const element = this;

        const popover = $(`[data-popover-id=${element.dataset.popover}]`);
        const popoverWrapper = popover.parent().parent();
        popoverWrapper.show();

        document.addEventListener('click', hidePopover);
        handlerExists = true;

        function hidePopover(e) {
          if (
            e.target !== popover.get(0) &&
            e.target !== element &&
            !element.contains(e.target)
          ) {
            popoverWrapper.hide();
            document.removeEventListener('click', hidePopover);
            handlerExists = false;
          }
        }
      }
    });
  })();
});

function wrapPopover(container, content) {
  const popover = document.createElement('div');
  popover.className = 'popover';
  popover.append(content);

  const arrowContent = document.createElement('div');
  arrowContent.className = 'popover-arrow-content';
  const arrowBorder = document.createElement('div');
  arrowBorder.className = 'popover-arrow-border';
  popover.append(arrowContent);
  popover.append(arrowBorder);

  const popoverWrapper = document.createElement('div');
  popoverWrapper.append(popover);
  popoverWrapper.className = 'position-absolute d-none';
  const popoverAlign = content.dataset.popoverAlign;
  if (popoverAlign) {
    popoverWrapper.style[popoverAlign] = 0;
    arrowContent.style[popoverAlign] = `${container.offsetWidth / 2}px`;
    arrowContent.style[`margin-${popoverAlign}`] = '-8px';
    arrowBorder.style[popoverAlign] = `${container.offsetWidth / 2}px`;
    arrowBorder.style[`margin-${popoverAlign}`] = '-9px';
  } else {
    const popoverDimensions = getElementDimensions(popoverWrapper);
    popoverWrapper.style.left = '50%';
    popoverWrapper.style.marginLeft = `-${popoverDimensions.width / 2}px`;
    arrowContent.style.left = '50%';
    arrowContent.style.marginLeft = '-8px';
    arrowBorder.style.left = '50%';
    arrowBorder.style.marginLeft = '-9px';
  }

  return popoverWrapper;
}

function getElementDimensions(element) {
  const helper = element.cloneNode(true);
  helper.style.display = 'block';
  helper.style.position = 'absolute';
  helper.style.top = '-100000px';
  helper.style.left = '-100000px';
  document.body.appendChild(helper);

  const height = helper.offsetHeight;
  const width = helper.offsetWidth;

  document.body.removeChild(helper);

  return {height, width};
}
